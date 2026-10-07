import 'package:flame/components.dart';

import '../asset_manifest.dart';
import '../park_path.dart';

/// A routed wooden sign standing at the side of the path, marking where a
/// session started or ended.
class WoodenSign extends SpriteComponent with HasGameReference {
  WoodenSign({required this.path, required this.atPixels})
    : super(anchor: Anchor.bottomCenter);

  /// How far to the side of the path the sign stands.
  static const double sideOffset = 70;

  final ParkPath path;
  final double atPixels;

  @override
  Future<void> onLoad() async {
    final image = await game.images.load(AssetManifest.woodenSign);
    sprite = Sprite(image);
    size = Vector2(image.width.toDouble(), image.height.toDouble());

    // Stand on the far (upper) side of the path so the runner passes in
    // front of it.
    final p = path.positionAt(atPixels);
    final d = path.directionAt(atPixels);
    var side = Vector2(d.dy, -d.dx);
    if (side.y > 0) side = -side;
    position = Vector2(p.dx, p.dy) + side * sideOffset;
    priority = 500000 + position.y.round();
  }
}
