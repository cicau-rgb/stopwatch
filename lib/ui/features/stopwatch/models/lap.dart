import '../../../../core/extensions/duration_extensions.dart';

class Lap {
  Lap({
    required this.lapNumber,
    required this.lapDuration,
    required this.totalElapsed,
  })  : formattedLapDuration = lapDuration.toStopwatchString,
        formattedTotalElapsed = totalElapsed.toStopwatchString;

  final int lapNumber;
  final Duration lapDuration;
  final Duration totalElapsed;
  final String formattedLapDuration;
  final String formattedTotalElapsed;

  static String formatDuration(Duration duration) => duration.toStopwatchString;

  Map<String, dynamic> toJson() => {
        'lapNumber': lapNumber,
        'lapDurationMs': lapDuration.inMilliseconds,
        'totalElapsedMs': totalElapsed.inMilliseconds,
      };

  factory Lap.fromJson(Map<String, dynamic> json) => Lap(
        lapNumber: json['lapNumber'] as int,
        lapDuration: Duration(milliseconds: json['lapDurationMs'] as int),
        totalElapsed: Duration(milliseconds: json['totalElapsedMs'] as int),
      );
}
