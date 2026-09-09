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
      expect(find.byKey(const Key('analog_clock_widget')), findsOneWidget);
    });

    testWidgets('renders AnalogDisplay with non-zero elapsed time',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AnalogDisplay(
              elapsed: Duration(minutes: 5, seconds: 30, milliseconds: 500),
            ),
          ),
        ),
      );

      expect(find.byType(AnalogDisplay), findsOneWidget);
      expect(find.byKey(const Key('analog_clock_widget')), findsOneWidget);
    });
  });
}
