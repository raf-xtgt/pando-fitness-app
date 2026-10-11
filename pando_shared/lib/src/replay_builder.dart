import 'dart:math' as math;

import 'gait_rules.dart';
import 'generated/protocol.dart';

/// Replay length: 1 s per real minute, clamped to [replayMinS]–[replayMaxS].
const double replayMinS = 15;
const double replayMaxS = 90;

/// Turns a walk's 30 s slices into a [Replay].
///
/// - Each slice's cadence gives its gait ([GaitRules.fromSteps]). Time with
///   no slice (the step history leaves out empty buckets) is standing.
/// - Distance comes from the steps the walker saw ([steps], the live counter)
///   × [strideM]. The slices give the shape: their steps are scaled to that
///   total, so the replay ends exactly at the walk's end sign.
/// - Next slices with the same gait merge into one segment.
/// - Each segment plays for its share of the real time.
///
/// With no slices but some steps (no step history), the whole walk is one
/// walking segment.
Replay buildReplay({
  required List<WalkSlice> slices,
  required DateTime startedAt,
  required DateTime endedAt,
  required int steps,
  required double strideM,
  required double startPathM,
}) {
  final distanceM = steps * strideM;
  final endPathM = startPathM + distanceM;
  final realS =
      math.max(0, endedAt.difference(startedAt).inMilliseconds) / 1000;
  final durationS = (realS / 60).clamp(replayMinS, replayMaxS).toDouble();

  // Time pieces in order: the slices, and standing for any gap between them.
  final pieces = <_Piece>[];
  var cursor = startedAt;
  final sorted = [...slices]..sort((a, b) => a.startAt.compareTo(b.startAt));
  for (final s in sorted) {
    final start = s.startAt.isBefore(cursor) ? cursor : s.startAt;
    final end = s.endAt.isAfter(endedAt) ? endedAt : s.endAt;
    if (!end.isAfter(start)) continue;
    if (start.isAfter(cursor)) pieces.add(_Piece(cursor, start, 0));
    pieces.add(_Piece(start, end, s.steps));
    cursor = end;
  }
  if (endedAt.isAfter(cursor)) pieces.add(_Piece(cursor, endedAt, 0));

  final sliceSteps = pieces.fold<int>(0, (sum, p) => sum + p.steps);
  if (sliceSteps == 0) {
    // No shape from the history: one segment for the whole walk.
    return Replay(
      startPathM: startPathM,
      endPathM: endPathM,
      distanceM: distanceM,
      realS: realS,
      durationS: durationS,
      segments: [
        ReplaySegment(
          fromM: startPathM,
          toM: endPathM,
          gait: steps > 0 ? Gait.walking : Gait.standing,
          realS: realS,
          playS: durationS,
        ),
      ],
    );
  }

  final metresPerSliceStep = distanceM / sliceSteps;
  final segments = <ReplaySegment>[];
  var atM = startPathM;
  for (final p in pieces) {
    final pieceS = p.end.difference(p.start).inMilliseconds / 1000;
    final gait = GaitRules.fromSteps(p.steps, p.end.difference(p.start));
    final toM = atM + p.steps * metresPerSliceStep;
    final playS = realS > 0 ? pieceS / realS * durationS : 0.0;
    final last = segments.isEmpty ? null : segments.last;
    if (last != null && last.gait == gait) {
      segments[segments.length - 1] = last.copyWith(
        toM: toM,
        realS: last.realS + pieceS,
        playS: last.playS + playS,
      );
    } else {
      segments.add(
        ReplaySegment(
          fromM: atM,
          toM: toM,
          gait: gait,
          realS: pieceS,
          playS: playS,
        ),
      );
    }
    atM = toM;
  }

  return Replay(
    startPathM: startPathM,
    endPathM: endPathM,
    distanceM: distanceM,
    realS: realS,
    durationS: durationS,
    segments: segments,
  );
}

/// Shortest real stretch the replay shows as its own chapter.
const double chapterMinRealS = 90;

/// [replay] in chapters: the whole session in a few long stretches
/// ("Walking 1.2 km for 18 min", then "Running …"), for the caption and the
/// runner.
///
/// While a segment is shorter than [minRealS] of real time, the shortest one
/// joins its longer neighbour and takes that neighbour's gait; next segments
/// with the same gait then merge. Speed inside a chapter is even (metres and
/// play time add up, so the replay still ends at the end sign on time).
Replay chapterReplay(Replay replay, {double minRealS = chapterMinRealS}) {
  final chapters = [...replay.segments];
  while (chapters.length > 1) {
    var shortest = 0;
    for (var i = 1; i < chapters.length; i++) {
      if (chapters[i].realS < chapters[shortest].realS) shortest = i;
    }
    if (chapters[shortest].realS >= minRealS) break;
    final before = shortest > 0 ? chapters[shortest - 1] : null;
    final after = shortest + 1 < chapters.length
        ? chapters[shortest + 1]
        : null;
    final intoBefore =
        after == null || (before != null && before.realS >= after.realS);
    final first = intoBefore ? shortest - 1 : shortest;
    final keep = intoBefore ? before! : after;
    chapters.replaceRange(first, first + 2, [
      _join(chapters[first], chapters[first + 1], keep.gait),
    ]);
    // A joined chapter can now sit next to one with the same gait.
    for (var i = chapters.length - 1; i > 0; i--) {
      if (chapters[i].gait == chapters[i - 1].gait) {
        chapters.replaceRange(i - 1, i + 1, [
          _join(chapters[i - 1], chapters[i], chapters[i].gait),
        ]);
      }
    }
  }
  return replay.copyWith(segments: chapters);
}

ReplaySegment _join(ReplaySegment a, ReplaySegment b, Gait gait) =>
    ReplaySegment(
      fromM: a.fromM,
      toM: b.toM,
      gait: gait,
      realS: a.realS + b.realS,
      playS: a.playS + b.playS,
    );

/// Index of the segment that plays at [playS] seconds; the last one after
/// the end.
int segmentAt(Replay replay, double playS) {
  var elapsed = 0.0;
  for (var i = 0; i < replay.segments.length; i++) {
    elapsed += replay.segments[i].playS;
    if (playS < elapsed) return i;
  }
  return replay.segments.length - 1;
}

/// Where the replay is at [playS] seconds: journey metres and gait. Before
/// the start it's the start sign; after the end, the end sign (standing).
({double metres, Gait gait}) replayAt(Replay replay, double playS) {
  var elapsed = 0.0;
  for (final s in replay.segments) {
    if (playS < elapsed + s.playS) {
      final t = s.playS > 0 ? (playS - elapsed) / s.playS : 1.0;
      final clamped = t.clamp(0.0, 1.0);
      return (metres: s.fromM + (s.toM - s.fromM) * clamped, gait: s.gait);
    }
    elapsed += s.playS;
  }
  return (metres: replay.endPathM, gait: Gait.standing);
}

class _Piece {
  _Piece(this.start, this.end, this.steps);

  final DateTime start;
  final DateTime end;
  final int steps;
}
