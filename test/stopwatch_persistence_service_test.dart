import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch_app/data/services/stopwatch_persistence_service.dart';
import 'package:stopwatch_app/ui/features/stopwatch/models/lap.dart';

void main() {
  group('StopwatchPersistenceService', () {
    late StopwatchPersistenceService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = StopwatchPersistenceService();
    });

    test('loadSnapshot returns null when no state is saved', () async {
      final snapshot = await service.loadSnapshot();
      expect(snapshot, isNull);
    });

    test('saves and loads snapshot correctly', () async {
      final laps = [
        Lap(
          lapNumber: 1,
          lapDuration: const Duration(seconds: 10),
          totalElapsed: const Duration(seconds: 10),
        ),
        Lap(
          lapNumber: 2,
          lapDuration: const Duration(seconds: 5),
          totalElapsed: const Duration(seconds: 15),
        ),
      ];

      await service.saveSnapshot(
        elapsed: const Duration(seconds: 15),
        laps: laps,
      );

      final snapshot = await service.loadSnapshot();
      expect(snapshot, isNotNull);
      expect(snapshot!.elapsed, equals(const Duration(seconds: 15)));
      expect(snapshot.laps.length, equals(2));
      expect(snapshot.laps[0].lapNumber, equals(1));
      expect(snapshot.laps[0].lapDuration, equals(const Duration(seconds: 10)));
      expect(snapshot.laps[1].lapNumber, equals(2));
      expect(snapshot.laps[1].lapDuration, equals(const Duration(seconds: 5)));
    });

    test('clear removes saved snapshot', () async {
      await service.saveSnapshot(
        elapsed: const Duration(seconds: 20),
        laps: [],
      );

      await service.clear();
      final snapshot = await service.loadSnapshot();
      expect(snapshot, isNull);
    });

    test('loadSnapshot safely falls back to empty laps on corrupted JSON',
        () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('stopwatch_elapsed_ms', 5000);
      await prefs.setString('stopwatch_laps_json', '{not-a-valid-json}');

      final snapshot = await service.loadSnapshot();
      expect(snapshot, isNotNull);
      expect(snapshot!.elapsed, equals(const Duration(seconds: 5)));
      expect(snapshot.laps, isEmpty);
    });
  });
}
