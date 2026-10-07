import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/game/park_path.dart';

void main() {
  // An L-shaped path: 300 px right, then 400 px down. Length 700.
  final path = ParkPath(const [Offset(0, 0), Offset(300, 0), Offset(300, 400)]);

  test('segment length and chain offset come from the polyline', () {
    expect(path.segmentLength, 700);
    expect(path.chainOffset, const Offset(300, 400));
  });

  test('positions inside the first copy follow the polyline', () {
    expect(path.positionAt(0), const Offset(0, 0));
    expect(path.positionAt(150), const Offset(150, 0));
    expect(path.positionAt(300), const Offset(300, 0));
    expect(path.positionAt(500), const Offset(300, 200));
  });

  test('the path never ends: later copies are offset end to end', () {
    expect(path.segmentIndex(700), 1);
    expect(path.positionAt(700), const Offset(300, 400));
    expect(path.positionAt(850), const Offset(450, 400));
    expect(path.positionAt(7000 + 150), const Offset(3150, 4000));
  });

  test('negative distances walk back into the previous copy', () {
    expect(path.segmentIndex(-1), -1);
    expect(path.positionAt(-200), const Offset(0, -200));
  });

  test('direction follows the current piece of the path', () {
    expect(path.directionAt(100), const Offset(1, 0));
    expect(path.directionAt(400), const Offset(0, 1));
    expect(path.directionAt(700 + 100), const Offset(1, 0));
  });

  test('Tiled isometric coordinates convert to map pixels', () {
    // Pando's park: 16x16 tiles of 256x128, path along tile row 8.5.
    final park = ParkPath.fromTiledIso(
      origin: const Offset(0, 1088),
      polyline: const [Offset(0, 0), Offset(2048, 0)],
      mapHeightTiles: 16,
      tileWidth: 256,
      tileHeight: 128,
    );
    expect(park.positionAt(0), const Offset(960, 544));
    expect(park.chainOffset, const Offset(2048, 1024));
  });
}
