import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/domain/units.dart';

void main() {
  test('inches convert to metres', () {
    expect(inchesToMetres(67), closeTo(1.7018, 1e-9));
    expect(inchesToMetres(48), closeTo(1.2192, 1e-9));
  });

  test('metres round to the nearest whole inch', () {
    expect(metresToInches(1.70), 67);
    expect(metresToInches(1.82), 72);
  });

  test('metres to inches round-trips every slider value', () {
    for (var i = minHeightInches; i <= maxHeightInches; i++) {
      expect(metresToInches(inchesToMetres(i)), i);
    }
  });

  test('out-of-range heights clamp to the slider range', () {
    expect(metresToInches(0.5), minHeightInches);
    expect(metresToInches(2.5), maxHeightInches);
  });

  test('heights format as feet and inches', () {
    expect(formatFeetInches(67), '5 ft 7 in');
    expect(formatFeetInches(48), '4 ft 0 in');
    expect(formatFeetInches(84), '7 ft 0 in');
  });

  test('stretch times: seconds, minutes, hours', () {
    expect(formatStretchTime(45), '45 s');
    expect(formatStretchTime(18 * 60 + 10), '18 min');
    expect(formatStretchTime(65 * 60), '1 h 5 min');
    expect(formatStretchTime(120 * 60), '2 h');
  });

  test('counts get thousands separators', () {
    expect(formatCount(0), '0');
    expect(formatCount(999), '999');
    expect(formatCount(12345), '12,345');
    expect(formatCount(1234567), '1,234,567');
  });
}
