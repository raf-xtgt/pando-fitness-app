import 'package:pando_server/src/generated/protocol.dart';
import 'package:pando_server/src/reports/hardcoded_message_source.dart';
import 'package:pando_server/src/reports/report_builder.dart';
import 'package:test/test.dart';

ActivitySession _session({
  required bool goalMet,
  required bool paceDropped,
  required Feel? feel,
}) => ActivitySession(
  profileId: 1,
  clientSessionId: 'x',
  startedAt: DateTime.utc(2026, 10, 7, 18),
  endedAt: DateTime.utc(2026, 10, 7, 18, 20),
  steps: goalMet ? 1162 : 600,
  strideM: 0.7055,
  distanceM: goalMet ? 820 : 423.3,
  goalSteps: 1000,
  goalM: 705.5,
  goalMet: goalMet,
  extraM: goalMet ? 90 : 0,
  feel: feel,
  stoppedEarly: !goalMet,
  paceDropped: paceDropped,
  startPathM: 0,
  endPathM: 820,
  reportReadyAt: DateTime.utc(2026, 10, 7, 18, 25),
);

void main() {
  const builder = ReportBuilder(HardcodedMessageSource());
  const shaming = [
    'fail',
    'lazy',
    'only ',
    'should have',
    'disappoint',
    'not enough',
    'bad',
  ];

  for (final goalMet in [true, false]) {
    for (final paceDropped in [true, false]) {
      for (final feel in [null, ...Feel.values]) {
        test(
          'goalMet=$goalMet paceDropped=$paceDropped feel=$feel '
          'gives a warm, filled-in message',
          () async {
            final message = await builder.message(
              _session(goalMet: goalMet, paceDropped: paceDropped, feel: feel),
            );
            expect(message, isNotEmpty);
            expect(message, isNot(contains('{')));
            expect(message, contains(goalMet ? '820 m' : '423 m'));
            if (goalMet) expect(message, contains('90 m'));
            for (final word in shaming) {
              expect(message.toLowerCase(), isNot(contains(word)));
            }
          },
        );
      }
    }
  }

  test('a missed goal never mentions extra distance', () {
    for (final byPace in HardcodedMessageSource.templates[false]!.values) {
      for (final text in byPace.values) {
        expect(text, isNot(contains('{extra}')));
      }
    }
  });
}
