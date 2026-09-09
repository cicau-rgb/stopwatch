import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/views/stopwatch_screen.dart';
import 'package:stopwatch_app/ui/features/stopwatch/views/widgets/analog_display.dart';
import 'package:stopwatch_app/ui/features/stopwatch/views/widgets/digital_display.dart';

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

      expect(find.text('STOPWATCH'), findsOneWidget);
      expect(find.text('00:00'), findsOneWidget);
      expect(find.text('.00'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Lap'), findsOneWidget);
      expect(find.byKey(const Key('lap_button_disabled')), findsOneWidget);
    });

    testWidgets('tapping Start changes control to Pause, enables Lap, and records laps',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byKey(const Key('start_button')));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Pause'), findsOneWidget);
      expect(find.byKey(const Key('lap_button')), findsOneWidget);
      expect(find.text('LAP'), findsOneWidget);
      expect(find.text('LAP TIME'), findsOneWidget);
      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('Lap 01'), findsOneWidget);

      await tester.tap(find.byKey(const Key('lap_button')));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Lap 02'), findsOneWidget);

      await tester.tap(find.byKey(const Key('pause_button')));
      await tester.pump();

      expect(find.text('Resume'), findsOneWidget);
      expect(find.byKey(const Key('reset_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pump();

      expect(find.text('Start'), findsOneWidget);
      expect(find.byKey(const Key('lap_button_disabled')), findsOneWidget);
      expect(find.text('00:00'), findsOneWidget);
      expect(find.text('.00'), findsOneWidget);
      expect(find.text('Lap 01'), findsNothing);
    });

    testWidgets('swiping switches between digital and analog displays',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(DigitalDisplay), findsOneWidget);

      await tester.fling(find.byType(PageView), const Offset(-500, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.byType(AnalogDisplay), findsOneWidget);

      await tester.fling(find.byType(PageView), const Offset(500, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.byType(DigitalDisplay), findsOneWidget);
    });
  });
}
