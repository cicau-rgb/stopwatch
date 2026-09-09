import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/views/widgets/analog_display.dart';

void main() {
  group('AnalogDisplay Widget Tests', () {
    testWidgets('renders AnalogDisplay with initial zero elapsed time',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AnalogDisplay(elapsed: Duration.zero),
          ),
        ),
      );

      expect(find.byType(AnalogDisplay), findsOneWidget);
      expect(find.byType(AnalogClock), findsOneWidget);
    });

    testWidgets('updates datetime when reset to zero elapsed time',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AnalogDisplay(
              elapsed: Duration(minutes: 5, seconds: 30),
            ),
          ),
        ),
      );

      final clockBeforeReset =
          tester.widget<AnalogClock>(find.byType(AnalogClock));
      expect(clockBeforeReset.datetime?.second, equals(30));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AnalogDisplay(
              elapsed: Duration.zero,
            ),
          ),
        ),
      );

      final clockAfterReset =
          tester.widget<AnalogClock>(find.byType(AnalogClock));
      expect(clockAfterReset.datetime?.second, equals(0));
      expect(clockAfterReset.datetime?.minute, equals(0));
      expect(clockAfterReset.datetime?.hour, equals(0));
    });
  });
}
