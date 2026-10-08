import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../asset_manifest.dart';

/// One copy of the park map, drawn at copy [index] along the endless path.
///
/// The ground (park, and the street rows around it) comes from flame_tiled.
/// Map objects (trees, bushes, pond, benches, rocks, fence, street
/// furniture) are drawn here from the map's `objects` layer, because
/// flame_tiled 3.x doesn't render tile objects itself. Objects are
/// depth-sorted by their base, so nearer things overlap farther ones.
class ParkSegment extends PositionComponent with HasGameReference {
  ParkSegment({
    required this.index,
    required this.map,
    required Vector2 offset,
  }) : super(position: offset, priority: index);

  final int index;

  /// Shared between all copies; each copy just draws it at its own offset.
  final RenderableTiledMap map;

  @override
  Future<void> onLoad() async {
    add(_Ground(map));

    final objects = map.getLayer<ObjectGroup>(AssetManifest.objectsLayer);
    if (objects == null) return;

    final tiled = map.map;
    final halfW = tiled.tileWidth / 2;
    final halfH = tiled.tileHeight / 2;
    final isoUnit = tiled.tileHeight.toDouble();

    for (final object in objects.objects) {
      final gid = object.gid;
      if (gid == null) continue;
      final source = tiled.tileByGid(gid)?.image?.source;
      if (source == null) continue;

      // Tiled stores isometric object positions in "iso units"; with
      // bottom alignment (x, y) is the image's bottom centre.
      final tx = object.x / isoUnit;
      final ty = object.y / isoUnit;
      final base = Vector2(
        (tx - ty) * halfW + tiled.height * halfW,
        (tx + ty) * halfH,
      );

      final image = await game.images.load(
        '${AssetManifest.parkObjectsFolder}$source',
      );
      add(
        SpriteComponent(
          sprite: Sprite(image),
          size: Vector2(object.width, object.height),
          position: base,
          anchor: Anchor.bottomCenter,
          priority: base.y.round(),
        ),
      );
    }
  }
}

class _Ground extends Component {
  _Ground(this.map) : super(priority: -1);

  final RenderableTiledMap map;

  @override
  void render(Canvas canvas) => map.render(canvas);
}
