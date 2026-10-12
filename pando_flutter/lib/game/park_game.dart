import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../app/theme.dart';
import '../domain/gait_detector.dart';
import 'asset_manifest.dart';
import 'components/mascot.dart';
import 'components/park_segment.dart';
import 'components/runner.dart';
import 'components/wooden_sign.dart';
import 'park_path.dart';

export 'components/mascot.dart' show MascotMove;

/// The isometric park. This is the map boundary: the Activity screen only
/// talks to the game through [setDistance], [setGait], [placeSign] and
/// [playMascot] (plus the start values passed in); the replay uses
/// [showAt]. The game knows nothing about steps or
/// the server.
class ParkGame extends FlameGame {
  ParkGame({
    this.resumeMetres = 0,
    this.signMetres = const [0],
    this.pixelsPerMetre = livePixelsPerMetre,
  });

  /// Tunable, live walk: map pixels per metre walked. One tile along the
  /// path is ~143 px, so an easy walk (~1.07 m/s) moves ~0.5 tile/s and a
  /// jog (~1.6 m/s) ~0.75 tile/s; one copy of the park is ~42 m (learner,
  /// 2026-10-12: at 7.8 the runner barely moved and hung at corners).
  static const double livePixelsPerMetre = 67;

  /// Tunable, replay: the whole walk plays in 15–90 s, so it keeps the
  /// smaller scale (~365 m per copy of the park) to stay watchable.
  static const double replayPixelsPerMetre = 7.8;

  /// Map pixels per metre for this game (signs and runner use it).
  final double pixelsPerMetre;

  /// Tunable: how many map pixels fit across the phone's width. At 700 the
  /// view stays on the park; the street rows around it fill the corners.
  static const double visibleWorldWidth = 700;

  /// Where along the journey this session starts.
  final double resumeMetres;

  /// Journey positions of the signs to show when the game starts.
  final List<double> signMetres;

  late final RenderableTiledMap _map;
  late final ParkPath _path;
  late final Runner _runner;
  late final Mascot _mascot;
  final Map<int, ParkSegment> _segments = {};

  @override
  Color backgroundColor() => PandoColors.paper;

  @override
  Future<void> onLoad() async {
    images.prefix = AssetManifest.imagePrefix;

    _map = await RenderableTiledMap.fromFile(
      AssetManifest.parkMap,
      Vector2(256, 128),
      prefix: AssetManifest.parkFolder,
      images: Images(prefix: AssetManifest.parkFolder),
      // Only the ground tilesets (park and street) go into the atlas; park
      // objects are drawn by ParkSegment (their tileset points outside the
      // park folder).
      tsxPackingFilter: (tileset) =>
          tileset.name == AssetManifest.parkTilesetName ||
          tileset.name == AssetManifest.streetTilesetName,
    );
    _path = _readPath(_map);

    final startPixels = resumeMetres * pixelsPerMetre;
    _runner = Runner(path: _path, startPixels: startPixels);

    _mascot = Mascot(path: _path, runner: _runner);

    _updateSegments();
    await world.addAll([
      for (final m in signMetres)
        WoodenSign(path: _path, atPixels: m * pixelsPerMetre),
      _runner,
      _mascot,
    ]);

    camera.viewfinder.anchor = const Anchor(0.5, 0.58);
    camera.follow(_runner);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (size.x > 0) camera.viewfinder.zoom = size.x / visibleWorldWidth;
  }

  /// Total journey distance (all sessions) to show the runner at.
  void setDistance(double metres) {
    if (!isLoaded) return;
    _runner.targetPixels = metres * pixelsPerMetre;
  }

  void setGait(Gait gait) {
    if (!isLoaded) return;
    _runner.gait = gait;
  }

  /// Replay: puts the runner exactly at [metres] with [gait], no glide (the
  /// replay moves faster than the live glide could follow).
  void showAt(double metres, Gait gait) {
    if (!isLoaded) return;
    _runner
      ..jumpTo(metres * pixelsPerMetre)
      ..gait = gait;
  }

  /// Puts a wooden sign at a journey position (metres), e.g. on Stop.
  void placeSign(double pathMetres) {
    if (!isLoaded) return;
    world.add(WoodenSign(path: _path, atPixels: pathMetres * pixelsPerMetre));
  }

  /// Plays a mascot move once (celebrate, first activity). Waits for the
  /// map to load first; completes when the move has finished.
  Future<void> playMascot(MascotMove move) async {
    await loaded;
    await _mascot.loaded;
    await _mascot.play(move);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isLoaded) _updateSegments();
  }

  /// Keeps only the current, previous and next copies of the park.
  void _updateSegments() {
    final current = _path.segmentIndex(_runner.displayedPixels);
    final wanted = {current - 1, current, current + 1};

    for (final index in _segments.keys.toList()) {
      if (!wanted.contains(index)) _segments.remove(index)!.removeFromParent();
    }
    for (final index in wanted) {
      if (_segments.containsKey(index)) continue;
      final offset = _path.chainOffset * index.toDouble();
      final segment = ParkSegment(
        index: index,
        map: _map,
        offset: Vector2(offset.dx, offset.dy),
      );
      _segments[index] = segment;
      world.add(segment);
    }
  }

  static ParkPath _readPath(RenderableTiledMap map) {
    final layer = map.getLayer<ObjectGroup>(AssetManifest.pathLayer)!;
    final line = layer.objects.firstWhere(
      (o) => o.name == AssetManifest.pathObject && o.isPolyline,
    );
    final tiled = map.map;
    return ParkPath.fromTiledIso(
      origin: Offset(line.x, line.y),
      polyline: [for (final p in line.polyline) Offset(p.x, p.y)],
      mapHeightTiles: tiled.height,
      tileWidth: tiled.tileWidth.toDouble(),
      tileHeight: tiled.tileHeight.toDouble(),
    );
  }
}
