import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';

/// Digital clock display rendering minutes, seconds, and milliseconds/hundredths
/// with tabular figures to eliminate jitter.
class DigitalDisplay extends StatelessWidget {
  const DigitalDisplay({
    super.key,
    required this.minutes,
    required this.seconds,
    required this.hundredths,
  });

  final String minutes;
  final String seconds;
  final String hundredths;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // Minutes : Seconds
            Text(
              '$minutes:$seconds',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 76,
                fontWeight: FontWeight.w200,
                letterSpacing: 2.0,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            // Milliseconds (Hundredths) Separator & Digits
            Text(
              '.$hundredths',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 38,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
