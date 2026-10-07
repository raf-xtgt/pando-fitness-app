import '../generated/protocol.dart';
import 'message_source.dart';

/// Builds the report message for a session: asks the [MessageSource] for the
/// text, then fills in the distances.
class ReportBuilder {
  const ReportBuilder(this._source);

  final MessageSource _source;

  Future<String> message(ActivitySession session) async {
    final text = await _source.message(ReportSignals.of(session));
    return text
        .replaceAll('{distance}', formatMetres(session.distanceM))
        .replaceAll('{extra}', formatMetres(session.extraM));
  }

  /// Whole metres, e.g. `820 m`.
  static String formatMetres(double metres) => '${metres.round()} m';
}
