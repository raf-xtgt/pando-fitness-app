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

/// A walk's distance: `210 m` below a kilometre, else `2.4 km`.
String formatWalkDistance(double metres) => metres >= 1000
    ? '${(metres / 1000).toStringAsFixed(1)} km'
    : '${metres.round()} m';

/// A stretch of real time: `45 s` below a minute, `18 min`, else `1 h 5 min`.
String formatStretchTime(double seconds) {
  if (seconds < 60) return '${seconds.round()} s';
  final minutes = (seconds / 60).round();
  if (minutes < 60) return '$minutes min';
  final rest = minutes % 60;
  return rest == 0 ? '${minutes ~/ 60} h' : '${minutes ~/ 60} h $rest min';
}
