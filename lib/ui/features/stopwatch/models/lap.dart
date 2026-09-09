class Lap {
  const Lap({
    required this.lapNumber,
    required this.lapDuration,
    required this.totalElapsed,
  });

  final int lapNumber;
  final Duration lapDuration;
  final Duration totalElapsed;

  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final hundredths =
        ((duration.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }

  String get formattedLapDuration => formatDuration(lapDuration);

  String get formattedTotalElapsed => formatDuration(totalElapsed);
}
