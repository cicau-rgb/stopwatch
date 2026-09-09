import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch_app/ui/features/stopwatch/view_models/stopwatch_view_model.dart';

class FakeStopwatch implements Stopwatch {
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;

  void setElapsed(Duration duration) {
    _elapsed = duration;
  }

  @override
  Duration get elapsed => _elapsed;

  @override
  int get elapsedMicroseconds => _elapsed.inMicroseconds;

  @override
  int get elapsedMilliseconds => _elapsed.inMilliseconds;

  @override
  int get elapsedTicks => _elapsed.inMicroseconds;

  @override
  int get frequency => 1000000;

  @override
  bool get isRunning => _isRunning;

  @override
  void reset() {
    _elapsed = Duration.zero;
  }

  @override
  void start() {
    _isRunning = true;
  }

  @override
  void stop() {
    _isRunning = false;
  }
}

void main() {
  group('StopwatchViewModel', () {
    late StopwatchViewModel viewModel;

    setUp(() {
      viewModel = StopwatchViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state is zero and idle', () {
      expect(viewModel.status, equals(StopwatchStatus.initial));
      expect(viewModel.isInitial, isTrue);
      expect(viewModel.isRunning, isFalse);
      expect(viewModel.isPaused, isFalse);
      expect(viewModel.formattedMinutes, equals('00'));
      expect(viewModel.formattedSeconds, equals('00'));
      expect(viewModel.formattedHundredths, equals('00'));
      expect(viewModel.formattedMilliseconds, equals('000'));
      expect(viewModel.fullFormattedTime, equals('00:00.00'));
      expect(viewModel.laps, isEmpty);
      expect(viewModel.currentLap, isNull);
    });

    test('start transitions status to running', () {
      viewModel.start();
      expect(viewModel.status, equals(StopwatchStatus.running));
      expect(viewModel.isRunning, isTrue);
      expect(viewModel.isInitial, isFalse);
      expect(viewModel.isPaused, isFalse);
      expect(viewModel.currentLap, isNotNull);
      expect(viewModel.currentLap!.lapNumber, equals(1));
    });

    test('pause transitions status to paused', () {
      viewModel.start();
      viewModel.pause();
      expect(viewModel.status, equals(StopwatchStatus.paused));
      expect(viewModel.isPaused, isTrue);
      expect(viewModel.isRunning, isFalse);
    });

    test('pause when not running does nothing', () {
      viewModel.pause();
      expect(viewModel.status, equals(StopwatchStatus.initial));
    });

    test('resume from paused transitions back to running', () {
      viewModel.start();
      viewModel.pause();
      viewModel.start();
      expect(viewModel.status, equals(StopwatchStatus.running));
      expect(viewModel.isRunning, isTrue);
    });

    test('recordLap when not running does nothing', () {
      viewModel.recordLap();
      expect(viewModel.laps, isEmpty);
    });

    test('records laps correctly with duration splits', () {
      final fakeStopwatch = FakeStopwatch();
      final vm = StopwatchViewModel(stopwatch: fakeStopwatch);

      vm.start();

      fakeStopwatch.setElapsed(const Duration(seconds: 10));
      vm.recordLap();

      expect(vm.laps.length, equals(1));
      expect(vm.laps.first.lapNumber, equals(1));
      expect(vm.laps.first.lapDuration, equals(const Duration(seconds: 10)));
      expect(vm.laps.first.totalElapsed, equals(const Duration(seconds: 10)));

      fakeStopwatch.setElapsed(const Duration(seconds: 25));
      vm.recordLap();

      expect(vm.laps.length, equals(2));
      expect(vm.laps.first.lapNumber, equals(2));
      expect(vm.laps.first.lapDuration, equals(const Duration(seconds: 15)));
      expect(vm.laps.first.totalElapsed, equals(const Duration(seconds: 25)));

      expect(vm.fastestLapNumber, equals(1));
      expect(vm.slowestLapNumber, equals(2));

      fakeStopwatch.setElapsed(const Duration(seconds: 30));
      vm.recordLap();

      expect(vm.laps.length, equals(3));
      expect(vm.laps.first.lapNumber, equals(3));
      expect(vm.laps.first.lapDuration, equals(const Duration(seconds: 5)));
      expect(vm.fastestLapNumber, equals(3));
      expect(vm.slowestLapNumber, equals(2));

      vm.dispose();
    });

    test('reset clears time, laps, and transitions back to initial', () {
      final fakeStopwatch = FakeStopwatch();
      final vm = StopwatchViewModel(stopwatch: fakeStopwatch);

      vm.start();
      fakeStopwatch.setElapsed(const Duration(seconds: 5));
      vm.recordLap();
      vm.pause();
      vm.reset();

      expect(vm.status, equals(StopwatchStatus.initial));
      expect(vm.isInitial, isTrue);
      expect(vm.fullFormattedTime, equals('00:00.00'));
      expect(vm.laps, isEmpty);
      expect(vm.currentLap, isNull);

      vm.dispose();
    });

    test('notifies listeners on start, pause, reset, and recordLap', () {
      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      viewModel.start();
      expect(notifyCount, greaterThanOrEqualTo(1));

      final countAfterStart = notifyCount;
      viewModel.recordLap();
      expect(notifyCount, greaterThan(countAfterStart));

      final countAfterLap = notifyCount;
      viewModel.pause();
      expect(notifyCount, greaterThan(countAfterLap));

      final countAfterPause = notifyCount;
      viewModel.reset();
      expect(notifyCount, greaterThan(countAfterPause));
    });

    test('correctly formats various durations', () {
      final fakeStopwatch = FakeStopwatch();
      final vm = StopwatchViewModel(stopwatch: fakeStopwatch);

      fakeStopwatch.setElapsed(Duration.zero);
      expect(vm.formattedMinutes, equals('00'));
      expect(vm.formattedSeconds, equals('00'));
      expect(vm.formattedHundredths, equals('00'));
      expect(vm.fullFormattedTime, equals('00:00.00'));

      fakeStopwatch.setElapsed(const Duration(milliseconds: 590));
      expect(vm.formattedMinutes, equals('00'));
      expect(vm.formattedSeconds, equals('00'));
      expect(vm.formattedHundredths, equals('59'));
      expect(vm.formattedMilliseconds, equals('590'));
      expect(vm.fullFormattedTime, equals('00:00.59'));

      fakeStopwatch.setElapsed(
        const Duration(minutes: 1, seconds: 5, milliseconds: 430),
      );
      expect(vm.formattedMinutes, equals('01'));
      expect(vm.formattedSeconds, equals('05'));
      expect(vm.formattedHundredths, equals('43'));
      expect(vm.fullFormattedTime, equals('01:05.43'));

      fakeStopwatch.setElapsed(
        const Duration(minutes: 72, seconds: 12, milliseconds: 90),
      );
      expect(vm.formattedMinutes, equals('72'));
      expect(vm.formattedSeconds, equals('12'));
      expect(vm.formattedHundredths, equals('09'));
      expect(vm.fullFormattedTime, equals('72:12.09'));

      vm.dispose();
    });
  });
}
