import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/features/mascot/mascot_sprite.dart';

void main() {
  const never = Duration(days: 1);

  test('the hover loop leaves out the blink frame', () {
    final frames = {
      for (var ms = 0; ms < 5000; ms += 25)
        MascotSprite.frameAt(Duration(milliseconds: ms), never),
    };
    expect(frames, {0, 1, 2, 3, 4, 6, 7});
  });

  test('a blink shows the blink frame, then the hover loop again', () {
    const blink = Duration(seconds: 3);
    expect(MascotSprite.frameAt(blink, blink), MascotSprite.blinkFrame);
    expect(
      MascotSprite.frameAt(blink + MascotSprite.blinkFor, blink),
      isNot(MascotSprite.blinkFrame),
    );
  });
}
