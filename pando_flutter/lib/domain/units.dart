/// Pure Dart: feet and inches for display, metres for storage.
library;

const double metresPerInch = 0.0254;

/// The height slider's range and default, in whole inches.
const int minHeightInches = 48; // 4 ft 0 in
const int maxHeightInches = 84; // 7 ft 0 in
const int defaultHeightInches = 67; // 5 ft 7 in

double inchesToMetres(int inches) => inches * metresPerInch;

/// Nearest whole inch, kept inside the slider's range.
int metresToInches(double metres) => (metres / metresPerInch).round().clamp(
  minHeightInches,
  maxHeightInches,
);

/// `5 ft 7 in`
String formatFeetInches(int inches) => '${inches ~/ 12} ft ${inches % 12} in';
