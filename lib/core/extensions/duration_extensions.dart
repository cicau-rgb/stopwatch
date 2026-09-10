extension DurationFormatting on Duration {
  String get formattedMinutes => inMinutes.toString().padLeft(2, '0');

  String get formattedSeconds => (inSeconds % 60).toString().padLeft(2, '0');

  String get formattedHundredths =>
      ((inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');

  String get formattedMilliseconds =>
      (inMilliseconds % 1000).toString().padLeft(3, '0');

  String get toStopwatchString =>
      '$formattedMinutes:$formattedSeconds.$formattedHundredths';
}
