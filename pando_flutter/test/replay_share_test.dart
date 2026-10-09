import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/domain/units.dart';
import 'package:pando_flutter/features/replay/replay_share.dart';

void main() {
  test('walk distances read as m below a kilometre, else km', () {
    expect(formatWalkDistance(209.6), '210 m');
    expect(formatWalkDistance(999.4), '999 m');
    expect(formatWalkDistance(2412), '2.4 km');
  });

  test('the share line names the distance and ends with the link', () {
    final link = Uri.parse('https://pando.example/replay/abc');
    final text = replayShareText(2412, link);
    expect(text, startsWith('I walked 2.4 km with Pando today.'));
    expect(text, endsWith('$link'));
  });
}
