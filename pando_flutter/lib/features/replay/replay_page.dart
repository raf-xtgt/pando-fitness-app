import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';
import 'package:pando_shared/pando_shared.dart';

import '../../domain/units.dart';
import 'replay_loading.dart';
import 'replay_player.dart';

/// The public replay page (`/replay/<replayId>`): the Pando name, a short
/// line, and the walk playing on the park. Nothing else about the walker.
class ReplayPage extends StatefulWidget {
  const ReplayPage({super.key, required this.client, required this.replayId});

  final Client client;

  /// From the link; null if the link has no valid id.
  final UuidValue? replayId;

  @override
  State<ReplayPage> createState() => _ReplayPageState();
}

class _ReplayPageState extends State<ReplayPage> {
  late final Future<Replay?> _replay = _load();

  Future<Replay?> _load() async {
    final id = widget.replayId;
    if (id == null) return null;
    return widget.client.replay.get(id);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Replay?>(
          future: _replay,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const ReplayLoading();
            }
            final replay = snap.data;
            if (replay == null) {
              return _Message(
                snap.hasError
                    ? "This replay couldn't load just now. Please try again."
                    : "This replay isn't here. Check the link?",
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    children: [
                      Text(
                        'Pando',
                        style: text.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A walk of ${formatWalkDistance(replay.distanceM)} '
                        'in ${_minutes(replay.realS)}, replayed on the park.',
                        textAlign: TextAlign.center,
                        style: text.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(child: ReplayPlayer(replay: replay)),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _minutes(double seconds) {
    final minutes = (seconds / 60).round();
    return minutes <= 1 ? 'about a minute' : '$minutes minutes';
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
  );
}
