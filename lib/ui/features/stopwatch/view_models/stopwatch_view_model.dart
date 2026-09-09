import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/lap.dart';

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
  final List<Lap> _laps = [];

  StopwatchStatus get status => _status;

  bool get isRunning => _status == StopwatchStatus.running;

  bool get isPaused => _status == StopwatchStatus.paused;

  bool get isInitial => _status == StopwatchStatus.initial;

  Duration get elapsed => _stopwatch.elapsed;

  List<Lap> get laps => List.unmodifiable(_laps);

  Lap? get currentLap {
    if (isInitial) return null;

    final prevTotal = _laps.isEmpty ? Duration.zero : _laps.first.totalElapsed;
    final currentTotal = elapsed;
    final currentDuration = currentTotal >= prevTotal
        ? currentTotal - prevTotal
        : Duration.zero;

    return Lap(
      lapNumber: _laps.length + 1,
      lapDuration: currentDuration,
      totalElapsed: currentTotal,
    );
  }

  int? get fastestLapNumber {
    if (_laps.length < 2) return null;
    Lap fastest = _laps.first;
    for (final lap in _laps) {
      if (lap.lapDuration < fastest.lapDuration) {
        fastest = lap;
      }
    }
    return fastest.lapNumber;
  }

  int? get slowestLapNumber {
    if (_laps.length < 2) return null;
    Lap slowest = _laps.first;
    for (final lap in _laps) {
      if (lap.lapDuration > slowest.lapDuration) {
        slowest = lap;
      }
    }
    return slowest.lapNumber;
  }

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

  void recordLap() {
    if (!isRunning) return;

    final prevTotal = _laps.isEmpty ? Duration.zero : _laps.first.totalElapsed;
    final currentTotal = elapsed;
    final lapDuration = currentTotal >= prevTotal
        ? currentTotal - prevTotal
        : Duration.zero;

    final lap = Lap(
      lapNumber: _laps.length + 1,
      lapDuration: lapDuration,
      totalElapsed: currentTotal,
    );

    _laps.insert(0, lap);
    notifyListeners();
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
    _timer = null;
    _status = StopwatchStatus.initial;
    _laps.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
