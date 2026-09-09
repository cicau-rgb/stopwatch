import 'dart:async';
import 'package:flutter/foundation.dart';

enum StopwatchStatus {
  initial,
  running,
  paused,
}

class StopwatchViewModel extends ChangeNotifier {
  StopwatchViewModel({
    Stopwatch? stopwatch,
    this.tickInterval = const Duration(milliseconds: 30),
  })  : _stopwatch = stopwatch ?? Stopwatch();

  final Stopwatch _stopwatch;
  final Duration tickInterval;
  Timer? _timer;
  StopwatchStatus _status = StopwatchStatus.initial;

  StopwatchStatus get status => _status;

  bool get isRunning => _status == StopwatchStatus.running;

  bool get isPaused => _status == StopwatchStatus.paused;

  bool get isInitial => _status == StopwatchStatus.initial;

  Duration get elapsed => _stopwatch.elapsed;

  String get formattedMinutes {
    final minutes = elapsed.inMinutes;
    return minutes.toString().padLeft(2, '0');
  }

  String get formattedSeconds {
    final seconds = elapsed.inSeconds % 60;
    return seconds.toString().padLeft(2, '0');
  }

  String get formattedHundredths {
    final hundredths = (elapsed.inMilliseconds % 1000) ~/ 10;
    return hundredths.toString().padLeft(2, '0');
  }

  String get formattedMilliseconds {
    final ms = elapsed.inMilliseconds % 1000;
    return ms.toString().padLeft(3, '0');
  }

  String get fullFormattedTime =>
      '$formattedMinutes:$formattedSeconds.$formattedHundredths';

  void start() {
    if (_status == StopwatchStatus.running) return;

    _stopwatch.start();
    _status = StopwatchStatus.running;
    _timer = Timer.periodic(tickInterval, (_) => notifyListeners());
    notifyListeners();
  }

  void pause() {
    if (_status != StopwatchStatus.running) return;

    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
    _status = StopwatchStatus.paused;
    notifyListeners();
  }

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
