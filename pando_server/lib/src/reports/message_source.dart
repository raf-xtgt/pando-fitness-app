import '../generated/protocol.dart';

/// What the report message is chosen from: the passive signals and the
/// optional "How did that feel?" answer.
class ReportSignals {
  const ReportSignals({
    required this.goalMet,
    required this.paceDropped,
    required this.stoppedEarly,
    required this.feel,
    required this.distanceM,
    required this.extraM,
  });

  factory ReportSignals.of(ActivitySession s) => ReportSignals(
    goalMet: s.goalMet,
    paceDropped: s.paceDropped,
    stoppedEarly: s.stoppedEarly,
    feel: s.feel,
    distanceM: s.distanceM,
    extraM: s.extraM,
  );

  final bool goalMet;
  final bool paceDropped;
  final bool stoppedEarly;
  final Feel? feel;
  final double distanceM;
  final double extraM;
}

/// Writes the report message. The PoC uses [HardcodedMessageSource]; an LLM
/// source can replace it in `server.dart` without other changes.
///
/// The text may hold `{distance}` and `{extra}`; the [ReportBuilder] fills
/// them in.
abstract interface class MessageSource {
  Future<String> message(ReportSignals signals);
}
