import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';

class AnalogDisplay extends StatelessWidget {
  const AnalogDisplay({
    super.key,
    required this.elapsed,
    this.secondHandColor = AppTheme.startAccent,
  });

  final Duration elapsed;
  final Color secondHandColor;

  @override
  Widget build(BuildContext context) {
    final displayDateTime = DateTime(
      2000,
      1,
      1,
      elapsed.inHours,
      elapsed.inMinutes % 60,
      elapsed.inSeconds % 60,
      elapsed.inMilliseconds % 1000,
    );

    return Center(
      child: SizedBox(
        width: 220.0,
        height: 220.0,
        child: AnalogClock(
          key: const Key('analog_clock_widget'),
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: AppTheme.surfaceElevated),
            color: AppTheme.surface,
            shape: BoxShape.circle,
          ),
          width: 220.0,
          height: 220.0,
          isLive: false,
          hourHandColor: AppTheme.textMuted,
          minuteHandColor: AppTheme.textPrimary,
          secondHandColor: secondHandColor,
          tickColor: AppTheme.textMuted,
          numberColor: AppTheme.textSecondary,
          showNumbers: true,
          showAllNumbers: false,
          textScaleFactor: 1.3,
          showTicks: true,
          showDigitalClock: false,
          showSecondHand: true,
          datetime: displayDateTime,
        ),
      ),
    );
  }
}
