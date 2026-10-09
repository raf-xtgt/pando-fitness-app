import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/main_replay.dart';

void main() {
  test('the replay id comes from /replay/<id>', () {
    const id = '01a1211e-9086-7fcf-bc4f-31a7d4eb6aa2';
    expect(
      replayIdFrom(Uri.parse('https://pando.example/replay/$id'))?.toString(),
      id,
    );
  });

  test('no id, or not a UUID, gives null', () {
    expect(replayIdFrom(Uri.parse('https://pando.example/replay/')), isNull);
    expect(replayIdFrom(Uri.parse('https://pando.example/replay/abc')), isNull);
    expect(replayIdFrom(Uri.parse('https://pando.example/')), isNull);
  });
}
