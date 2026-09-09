import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/models/lap.dart';
import 'package:stopwatch_app/ui/features/stopwatch/view_models/stopwatch_view_model.dart';

class LapListView extends StatelessWidget {
  const LapListView({
    super.key,
    required this.viewModel,
  });

  final StopwatchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isInitial) {
      return const SizedBox.shrink();
    }

    final currentLap = viewModel.currentLap;
    final recordedLaps = viewModel.laps;
    final fastestLapNumber = viewModel.fastestLapNumber;
    final slowestLapNumber = viewModel.slowestLapNumber;

    final allDisplayLaps = <Lap>[
      ?currentLap,
      ...recordedLaps,
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LAP',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'LAP TIME',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'TOTAL',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: AppTheme.surfaceElevated,
          height: 1,
          thickness: 1,
        ),
        Expanded(
          child: ListView.separated(
            key: const Key('lap_list_view'),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            itemCount: allDisplayLaps.length,
            separatorBuilder: (context, index) => const Divider(
              color: AppTheme.surfaceElevated,
              height: 1,
              thickness: 0.5,
            ),
            itemBuilder: (context, index) {
              final lap = allDisplayLaps[index];
              final isLiveLap = index == 0 && currentLap != null;

              Color timeColor = AppTheme.textPrimary;
              if (!isLiveLap) {
                if (lap.lapNumber == fastestLapNumber) {
                  timeColor = AppTheme.startAccent;
                } else if (lap.lapNumber == slowestLapNumber) {
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
            },
          ),
        ),
      ],
    );
  }
}
