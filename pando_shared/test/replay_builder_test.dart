import 'package:pando_shared/pando_shared.dart';
import 'package:test/test.dart';

void main() {
  final start = DateTime.utc(2026, 10, 9, 8);
  DateTime at(int seconds) => start.add(Duration(seconds: seconds));

  WalkSlice slice(int index, int steps) => WalkSlice(
    clientSessionId: 'w',
    startAt: at(30 * index),
    endAt: at(30 * (index + 1)),
    steps: steps,
  );

  Replay build(List<WalkSlice> slices, {int? steps, int? seconds}) =>
      buildReplay(
        slices: slices,
        startedAt: start,
        endedAt: at(seconds ?? 30 * slices.length),
        steps: steps ?? slices.fold(0, (sum, s) => sum + s.steps),
        strideM: 0.7,
        startPathM: 100,
      );

  test(
    'walk → run → walk gives walking, running, walking at the right metres',
    () {
      // The phone test: 51, 50 | 66, 73 | 50, 49 steps per 30 s.
      final replay = build([
        slice(0, 51),
        slice(1, 50),
        slice(2, 66),
        slice(3, 73),
        slice(4, 50),
        slice(5, 49),
      ]);
      expect(replay.segments.map((s) => s.gait), [
        Gait.walking,
        Gait.running,
        Gait.walking,
      ]);
      final walk1 = replay.segments[0];
      final run = replay.segments[1];
      expect(walk1.fromM, 100);
      expect(walk1.toM, closeTo(100 + 101 * 0.7, 1e-9));
      expect(run.fromM, walk1.toM);
      expect(run.toM, closeTo(100 + 240 * 0.7, 1e-9));
      expect(replay.segments.last.toM, closeTo(replay.endPathM, 1e-9));
      expect(replay.endPathM, closeTo(100 + 339 * 0.7, 1e-9));
      expect(walk1.realS, 60);
    },
  );

  test('replay length: 1 s per minute, 15 to 90 s', () {
    expect(build([slice(0, 50)], seconds: 5 * 60).durationS, 15);
    expect(build([slice(0, 50)], seconds: 30 * 60).durationS, 30);
    expect(build([slice(0, 50)], seconds: 2 * 3600).durationS, 90);
  });

  test('segment play times add up to the replay length', () {
    final replay = build([slice(0, 50), slice(1, 70), slice(2, 0)]);
    final total = replay.segments.fold(0.0, (sum, s) => sum + s.playS);
    expect(total, closeTo(replay.durationS, 1e-9));
  });

  test('a slice with no steps, and a missing slice, are standing', () {
    // Slice 1 has 0 steps; slice 3 is missing (the history leaves out
    // empty buckets).
    final replay = build([
      slice(0, 50),
      slice(1, 0),
      slice(2, 50),
      slice(4, 50),
    ], seconds: 150);
    expect(replay.segments.map((s) => s.gait), [
      Gait.walking,
      Gait.standing,
      Gait.walking,
      Gait.standing,
      Gait.walking,
    ]);
    final gap = replay.segments[3];
    expect(gap.fromM, gap.toM);
    expect(gap.realS, 30);
  });

  test('slices are scaled to the counter total (shape from the slices)', () {
    // History says 100 steps, the counter said 110.
    final replay = build([slice(0, 50), slice(1, 50)], steps: 110);
    expect(replay.distanceM, closeTo(77, 1e-9));
    expect(replay.segments.single.toM, closeTo(177, 1e-9));
  });

  test('no slices but steps: one walking segment for the whole walk', () {
    final replay = build([], steps: 200, seconds: 120);
    expect(replay.segments, hasLength(1));
    expect(replay.segments.single.gait, Gait.walking);
    expect(replay.segments.single.toM, closeTo(240, 1e-9));
    expect(replay.durationS, 15);
  });

  test('replayAt walks through the segments and ends at the end sign', () {
    final replay = build([slice(0, 50), slice(1, 70)], seconds: 60);
    // 1 min → 15 s; each slice plays 7.5 s.
    expect(replayAt(replay, 0).metres, 100);
    expect(replayAt(replay, 0).gait, Gait.walking);
    expect(replayAt(replay, 3.75).metres, closeTo(100 + 25 * 0.7, 1e-9));
    expect(replayAt(replay, 7.5).gait, Gait.running);
    expect(replayAt(replay, 99).metres, replay.endPathM);
    expect(replayAt(replay, 99).gait, Gait.standing);
  });
}
