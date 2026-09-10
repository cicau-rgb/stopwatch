import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch_app/core/extensions/duration_extensions.dart';

void main() {
  group('DurationFormatting extension', () {
    test('formats zero duration correctly', () {
      const duration = Duration.zero;

      expect(duration.formattedMinutes, equals('00'));
      expect(duration.formattedSeconds, equals('00'));
      expect(duration.formattedHundredths, equals('00'));
      expect(duration.formattedMilliseconds, equals('000'));
      expect(duration.toStopwatchString, equals('00:00.00'));
    });

    test('formats sub-second duration correctly', () {
      const duration = Duration(milliseconds: 590);

      expect(duration.formattedMinutes, equals('00'));
      expect(duration.formattedSeconds, equals('00'));
      expect(duration.formattedHundredths, equals('59'));
      expect(duration.formattedMilliseconds, equals('590'));
      expect(duration.toStopwatchString, equals('00:00.59'));
    });

    test('formats minute, second, and hundredth split correctly', () {
      const duration = Duration(
        minutes: 1,
        seconds: 5,
        milliseconds: 430,
      );

      expect(duration.formattedMinutes, equals('01'));
      expect(duration.formattedSeconds, equals('05'));
      expect(duration.formattedHundredths, equals('43'));
      expect(duration.formattedMilliseconds, equals('430'));
      expect(duration.toStopwatchString, equals('01:05.43'));
    });

    test('formats multi-hour duration correctly', () {
      const duration = Duration(
        minutes: 72,
        seconds: 12,
        milliseconds: 90,
      );

      expect(duration.formattedMinutes, equals('72'));
      expect(duration.formattedSeconds, equals('12'));
      expect(duration.formattedHundredths, equals('09'));
      expect(duration.formattedMilliseconds, equals('090'));
      expect(duration.toStopwatchString, equals('72:12.09'));
    });

    test('handles small single-digit millisecond values', () {
      const duration = Duration(milliseconds: 7);

      expect(duration.formattedMinutes, equals('00'));
      expect(duration.formattedSeconds, equals('00'));
      expect(duration.formattedHundredths, equals('00'));
      expect(duration.formattedMilliseconds, equals('007'));
      expect(duration.toStopwatchString, equals('00:00.00'));
    });
  });
}
