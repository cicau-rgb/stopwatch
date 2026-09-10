import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/features/stopwatch/models/lap.dart';

class StopwatchSnapshot {
  const StopwatchSnapshot({
    required this.elapsed,
    required this.laps,
  });

  final Duration elapsed;
  final List<Lap> laps;
}

class StopwatchPersistenceService {
  static const String _keyElapsedMs = 'stopwatch_elapsed_ms';
  static const String _keyLapsJson = 'stopwatch_laps_json';

  Future<void> saveSnapshot({
    required Duration elapsed,
    required List<Lap> laps,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyElapsedMs, elapsed.inMilliseconds);
    final lapsList = laps.map((l) => l.toJson()).toList();
    await prefs.setString(_keyLapsJson, jsonEncode(lapsList));
  }

  Future<StopwatchSnapshot?> loadSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    final elapsedMs = prefs.getInt(_keyElapsedMs);
    if (elapsedMs == null) return null;

    final lapsJson = prefs.getString(_keyLapsJson);
    List<Lap> laps = [];
    if (lapsJson != null && lapsJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(lapsJson) as List<dynamic>;
        laps = decoded
            .map((item) => Lap.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        laps = [];
      }
    }

    return StopwatchSnapshot(
      elapsed: Duration(milliseconds: elapsedMs),
      laps: laps,
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyElapsedMs);
    await prefs.remove(_keyLapsJson);
  }
}
