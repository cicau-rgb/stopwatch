import 'dart:async';
import 'package:flutter/foundation.dart';

/// Lifecycle status for the stopwatch engine.
enum StopwatchStatus {
  initial,
  running,
  paused,
}

/// ViewModel managing stopwatch state, ticking interval, and formatted time values.
class StopwatchViewModel extends ChangeNotifier {
  StopwatchViewModel({
    Stopwatch? stopwatch,
    this.tickInterval = const Duration(milliseconds: 30),
  })  : _stopwatch = stopwatch ?? Stopwatch();

  final Stopwatch _stopwatch;
  final Duration tickInterval;
  Timer? _timer;
  StopwatchStatus _status = StopwatchStatus.initial;

  /// Current stopwatch status.
  StopwatchStatus get status => _status;

  /// True if stopwatch is currently running.
  bool get isRunning => _status == StopwatchStatus.running;

  /// True if stopwatch is paused (has elapsed time, not running).
  bool get isPaused => _status == StopwatchStatus.paused;

  /// True if stopwatch is at initial reset state (0 time).
  bool get isInitial => _status == StopwatchStatus.initial;

  /// Total elapsed time duration.
  Duration get elapsed => _stopwatch.elapsed;

  /// Padded 2-digit minutes string (e.g. "00", "05", "59").
  String get formattedMinutes {
    final minutes = elapsed.inMinutes;
    return minutes.toString().padLeft(2, '0');
  }

  /// Padded 2-digit seconds string (e.g. "00", "09", "59").
  String get formattedSeconds {
    final seconds = elapsed.inSeconds % 60;
    return seconds.toString().padLeft(2, '0');
  }

  /// Padded 2-digit hundredths of a second (10ms resolution, e.g. "00" to "99").
  String get formattedHundredths {
    final hundredths = (elapsed.inMilliseconds % 1000) ~/ 10;
    return hundredths.toString().padLeft(2, '0');
  }

  /// Padded 3-digit milliseconds (e.g. "000" to "999").
  String get formattedMilliseconds {
    final ms = elapsed.inMilliseconds % 1000;
    return ms.toString().padLeft(3, '0');
  }

  /// Full formatted string "MM:SS.ss".
  String get fullFormattedTime =>
      '$formattedMinutes:$formattedSeconds.$formattedHundredths';

  /// Starts or resumes the stopwatch.
  void start() {
    if (_status == StopwatchStatus.running) return;

    _stopwatch.start();
    _status = StopwatchStatus.running;
    _timer = Timer.periodic(tickInterval, (_) => notifyListeners());
    notifyListeners();
  }

  /// Pauses the stopwatch.
  void pause() {
    if (_status != StopwatchStatus.running) return;

    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
    _status = StopwatchStatus.paused;
    notifyListeners();
  }

  /// Resets the stopwatch to 00:00.00 and initial state.
  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
    _timer = null;
    _status = StopwatchStatus.initial;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
