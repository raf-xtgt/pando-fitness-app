import 'maintenance_alarm.dart';

/// Development: the local server is always on, so there is nothing to wake.
class NoopAlarm implements MaintenanceAlarm {
  const NoopAlarm();

  @override
  Future<void> ringAt(DateTime time) async {}
}
