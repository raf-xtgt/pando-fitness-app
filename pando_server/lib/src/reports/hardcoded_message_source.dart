import '../generated/protocol.dart';
import 'message_source.dart';

/// Warm, fixed messages keyed by goalMet × paceDropped × feel. No line ever
/// shames: missing the goal still gets a kind message.
class HardcodedMessageSource implements MessageSource {
  const HardcodedMessageSource();

  /// `null` feel means the question was skipped.
  static const Map<bool, Map<bool, Map<Feel?, String>>> templates = {
    true: {
      false: {
        null: 'Good job, you did {distance} today with {extra} extra!!',
        Feel.tooEasy:
            '{distance} today and {extra} extra, and it felt easy. '
            'You are ready for more!',
        Feel.justRight:
            '{distance} today with {extra} extra, at just the right pace. '
            'Lovely walk!',
        Feel.tooHard:
            'You pushed through: {distance} today with {extra} extra. '
            'Rest well, you earned it.',
      },
      true: {
        null:
            'Good job, you did {distance} today with {extra} extra! '
            'Slowing down at the end is fine.',
        Feel.tooEasy:
            '{distance} today and {extra} extra. You eased off at the end, '
            'and still beat your goal!',
        Feel.justRight:
            '{distance} today with {extra} extra. A gentle finish to a good '
            'walk.',
        Feel.tooHard:
            '{distance} today with {extra} extra, even when it got tough. '
            'Take it easy now.',
      },
    },
    false: {
      false: {
        null: 'You did {distance} today. Every step counts!',
        Feel.tooEasy:
            '{distance} today, and it felt easy. Next time, see how far '
            'the path goes!',
        Feel.justRight:
            '{distance} today at a pace that felt right. That is a good '
            'walk.',
        Feel.tooHard:
            '{distance} today. Hard days count too, and you showed up.',
      },
      true: {
        null:
            'You did {distance} today. Listening to your body is part '
            'of the journey.',
        Feel.tooEasy:
            '{distance} today. Your sign is on the map, ready for your next '
            'walk.',
        Feel.justRight:
            '{distance} today, and you slowed down when you needed to. '
            'Nice one.',
        Feel.tooHard:
            '{distance} today. It was a tough one, so rest up. Your sign '
            'is waiting for you.',
      },
    },
  };

  @override
  Future<String> message(ReportSignals signals) async =>
      templates[signals.goalMet]![signals.paceDropped]![signals.feel]!;
}
