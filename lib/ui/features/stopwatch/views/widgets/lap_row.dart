import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import '../../models/lap.dart';

class LapRow extends StatelessWidget {
  const LapRow({
    super.key,
    required this.lap,
    this.isLiveLap = false,
    this.isFastest = false,
    this.isSlowest = false,
  });

  final Lap lap;
  final bool isLiveLap;
  final bool isFastest;
  final bool isSlowest;

  @override
  Widget build(BuildContext context) {
    Color timeColor = AppTheme.textPrimary;
    if (!isLiveLap) {
      if (isFastest) {
        timeColor = AppTheme.startAccent;
      } else if (isSlowest) {
        timeColor = AppTheme.pauseAccent;
      }
    }

    final lapLabel = 'Lap ${lap.lapNumber.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lapLabel,
            style: TextStyle(
              color: isLiveLap ? AppTheme.textSecondary : AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            lap.formattedLapDuration,
            style: TextStyle(
              color: timeColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            lap.formattedTotalElapsed,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
