import 'notifications/maintenance_alarm.dart';
import 'notifications/noop_alarm.dart';
import 'notifications/push_sender.dart';
import 'reports/hardcoded_message_source.dart';
import 'reports/message_source.dart';
import 'reports/report_builder.dart';

/// The swappable parts of the report flow. `server.dart` sets them at
/// startup; the defaults are safe for tests and need no credentials.
abstract final class PandoServices {
  /// Swap for an LLM source here; nothing else changes.
  static MessageSource messageSource = const HardcodedMessageSource();

  static MaintenanceAlarm alarm = const NoopAlarm();

  static PushSender push = LogPushSender(print);

  /// `demo.seedThreeSessions` only works when this is on (`allowDemoSeed`
  /// in `config/<run mode>.yaml`).
  static bool allowDemoSeed = false;

  static ReportBuilder get reportBuilder => ReportBuilder(messageSource);
}
