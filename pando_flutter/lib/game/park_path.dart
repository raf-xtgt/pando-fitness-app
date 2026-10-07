import 'dart:math' as math;
import 'dart:ui';

/// Turns "pixels along the journey" into a position on the endless park.
///
/// The park map has one polyline that enters at one edge and leaves at the
/// opposite edge. Copy N of the map is drawn offset by N × [chainOffset]
/// (path end − path start), so the copies line up end to end and the path
/// never ends. Negative distances walk back into earlier copies.
class ParkPath {
  ParkPath(List<Offset> points)
    : assert(points.length >= 2, 'A path needs at least two points'),
      _points = List.unmodifiable(points),
      chainOffset = points.last - points.first {
    var total = 0.0;
    _cumulative.add(0);
    for (var i = 1; i < _points.length; i++) {
      total += (_points[i] - _points[i - 1]).distance;
      _cumulative.add(total);
    }
    segmentLength = total;
  }

  /// Builds the path from a Tiled isometric polyline. Tiled stores isometric
  /// object coordinates in "iso units" (one tile = [tileHeight] units on both
  /// axes); this converts them to the map's pixel space.
  factory ParkPath.fromTiledIso({
    required Offset origin,
    required List<Offset> polyline,
    required int mapHeightTiles,
    required double tileWidth,
    required double tileHeight,
  }) {
    final halfW = tileWidth / 2;
    final halfH = tileHeight / 2;
    Offset toScreen(Offset iso) {
      final tx = iso.dx / tileHeight;
      final ty = iso.dy / tileHeight;
      return Offset(
        (tx - ty) * halfW + mapHeightTiles * halfW,
        (tx + ty) * halfH,
      );
    }

    return ParkPath([for (final p in polyline) toScreen(origin + p)]);
  }

  final List<Offset> _points;
  final List<double> _cumulative = [];

  /// Path end − path start: where copy N+1 sits relative to copy N.
  final Offset chainOffset;

  /// Length of the path through one copy of the map, in pixels.
  late final double segmentLength;

  /// Which copy of the map [pixels] falls in.
  int segmentIndex(double pixels) => (pixels / segmentLength).floor();

  /// Map position (in copy-0 pixel space) after travelling [pixels].
  Offset positionAt(double pixels) {
    final (segment, index, t) = _locate(pixels);
    final a = _points[index];
    final b = _points[index + 1];
    return Offset.lerp(a, b, t)! + chainOffset * segment.toDouble();
  }

  /// Unit direction of travel at [pixels].
  Offset directionAt(double pixels) {
    final (_, index, _) = _locate(pixels);
    final d = _points[index + 1] - _points[index];
    return d / d.distance;
  }

  (int segment, int index, double t) _locate(double pixels) {
    final segment = segmentIndex(pixels);
    final local = pixels - segment * segmentLength;
    var index = _upperBound(local) - 1;
    index = math.max(0, math.min(index, _points.length - 2));
    final start = _cumulative[index];
    final length = _cumulative[index + 1] - start;
    final t = length == 0 ? 0.0 : ((local - start) / length).clamp(0.0, 1.0);
    return (segment, index, t);
  }

  /// First index whose cumulative length is greater than [local].
  int _upperBound(double local) {
    var lo = 0;
    var hi = _cumulative.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (_cumulative[mid] <= local) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}
