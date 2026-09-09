class Lap {
  Lap({
    required this.lapNumber,
    required this.lapDuration,
    required this.totalElapsed,
  })  : formattedLapDuration = formatDuration(lapDuration),
        formattedTotalElapsed = formatDuration(totalElapsed);

  final int lapNumber;
  final Duration lapDuration;
  final Duration totalElapsed;
  final String formattedLapDuration;
  final String formattedTotalElapsed;

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final hundredths =
        ((duration.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }
}
