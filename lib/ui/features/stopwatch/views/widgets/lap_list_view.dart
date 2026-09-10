import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/view_models/stopwatch_view_model.dart';
import 'lap_row.dart';

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
    final hasCurrentLap = currentLap != null;
    final totalItemCount = recordedLaps.length + (hasCurrentLap ? 1 : 0);
    final fastestLapNumber = viewModel.fastestLapNumber;
    final slowestLapNumber = viewModel.slowestLapNumber;

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
            itemCount: totalItemCount,
            separatorBuilder: (context, index) => const Divider(
              color: AppTheme.surfaceElevated,
              height: 1,
              thickness: 0.5,
            ),
            itemBuilder: (context, index) {
              final isLiveLap = hasCurrentLap && index == 0;
              final lap = isLiveLap
                  ? currentLap
                  : recordedLaps[hasCurrentLap ? index - 1 : index];

              return LapRow(
                lap: lap,
                isLiveLap: isLiveLap,
                isFastest: !isLiveLap && lap.lapNumber == fastestLapNumber,
                isSlowest: !isLiveLap && lap.lapNumber == slowestLapNumber,
              );
            },
          ),
        ),
      ],
    );
  }
}
