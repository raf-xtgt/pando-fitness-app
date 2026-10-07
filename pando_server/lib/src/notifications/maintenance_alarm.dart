/// Wakes whoever runs due future calls. `session.save` rings it right after
/// it schedules the report notification.
///
/// Locally the always-on server runs future calls by itself ([NoopAlarm]).
/// On Cloud Run the serverless service only schedules them, so a Cloud Task
/// starts the `pando-maintenance` job (`CloudTasksAlarm`, slice 6).
abstract interface class MaintenanceAlarm {
  Future<void> ringAt(DateTime time);
}
