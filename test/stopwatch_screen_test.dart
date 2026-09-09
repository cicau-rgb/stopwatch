import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/views/stopwatch_screen.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: const StopwatchScreen(),
    );
  }

  group('StopwatchScreen Widget Tests', () {
    testWidgets('renders initial 00:00.00 display and controls', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Header
      expect(find.text('STOPWATCH'), findsOneWidget);

      // Digital display
      expect(find.text('00:00'), findsOneWidget);
      expect(find.text('.00'), findsOneWidget);

      // Buttons
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
    });

    testWidgets('tapping Start changes control to Pause and ticks time', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap start
      await tester.tap(find.byKey(const Key('start_button')));
      await tester.pump(const Duration(milliseconds: 100));

      // Button should now be Pause
      expect(find.text('Pause'), findsOneWidget);
      expect(find.text('Start'), findsNothing);

      // Tap pause
      await tester.tap(find.byKey(const Key('pause_button')));
      await tester.pump();

      // Button should now be Resume
      expect(find.text('Resume'), findsOneWidget);

      // Tap reset
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pump();

      // Should be back to Start and 00:00 .00
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('00:00'), findsOneWidget);
      expect(find.text('.00'), findsOneWidget);
    });
  });
}
