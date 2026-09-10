import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:stopwatch_app/core/extensions/duration_extensions.dart';
import 'package:stopwatch_app/data/services/stopwatch_persistence_service.dart';
import '../models/lap.dart';

enum StopwatchStatus {
  initial,
  running,
  paused,
}

class StopwatchViewModel extends ChangeNotifier {
  StopwatchViewModel({
    Stopwatch? stopwatch,
    StopwatchPersistenceService? persistenceService,
    this.tickInterval = const Duration(milliseconds: 30),
  })  : _stopwatch = stopwatch ?? Stopwatch(),
        _persistenceService =
            persistenceService ?? StopwatchPersistenceService();

  final Stopwatch _stopwatch;
  final StopwatchPersistenceService _persistenceService;
  final Duration tickInterval;
  Timer? _timer;
  Duration _elapsedOffset = Duration.zero;
  StopwatchStatus _status = StopwatchStatus.initial;
  final List<Lap> _laps = [];
  int? _fastestLapNumber;
  int? _slowestLapNumber;

  StopwatchStatus get status => _status;

  bool get isRunning => _status == StopwatchStatus.running;

  bool get isPaused => _status == StopwatchStatus.paused;

  bool get isInitial => _status == StopwatchStatus.initial;

  Duration get elapsed => _elapsedOffset + _stopwatch.elapsed;

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

  int? get fastestLapNumber => _fastestLapNumber;

  int? get slowestLapNumber => _slowestLapNumber;

  String get formattedMinutes => elapsed.formattedMinutes;

  String get formattedSeconds => elapsed.formattedSeconds;

  String get formattedHundredths => elapsed.formattedHundredths;

  String get formattedMilliseconds => elapsed.formattedMilliseconds;

  String get fullFormattedTime => elapsed.toStopwatchString;

  void start() {
    if (_status == StopwatchStatus.running) return;

    _timer?.cancel();
    _stopwatch.start();
    _status = StopwatchStatus.running;
    _timer = Timer.periodic(tickInterval, (_) {
      if (!hasListeners) return;
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    if (_status != StopwatchStatus.running) return;

    _stopwatch.stop();
    _elapsedOffset += _stopwatch.elapsed;
    _stopwatch.reset();
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
    _updateLapStats();
    notifyListeners();
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _elapsedOffset = Duration.zero;
    _timer?.cancel();
    _timer = null;
    _status = StopwatchStatus.initial;
    _laps.clear();
    _fastestLapNumber = null;
    _slowestLapNumber = null;
    _persistenceService.clear();
    notifyListeners();
  }

  Future<void> persistCurrentState() async {
    if (isInitial) {
      await _persistenceService.clear();
      return;
    }
    if (isRunning) {
      pause();
    }
    await _persistenceService.saveSnapshot(
      elapsed: elapsed,
      laps: _laps,
    );
  }

  Future<void> restoreState() async {
    final snapshot = await _persistenceService.loadSnapshot();
    if (snapshot == null || snapshot.elapsed == Duration.zero) return;

    _elapsedOffset = snapshot.elapsed;
    _status = StopwatchStatus.paused;
    _laps.clear();
    _laps.addAll(snapshot.laps);
    _updateLapStats();
    notifyListeners();
  }

  void _updateLapStats() {
    if (_laps.length < 2) {
      _fastestLapNumber = null;
      _slowestLapNumber = null;
      return;
    }

    Lap fastest = _laps.first;
    Lap slowest = _laps.first;

    for (final lap in _laps) {
      if (lap.lapDuration < fastest.lapDuration) {
        fastest = lap;
      }
      if (lap.lapDuration > slowest.lapDuration) {
        slowest = lap;
      }
    }

    _fastestLapNumber = fastest.lapNumber;
    _slowestLapNumber = slowest.lapNumber;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
