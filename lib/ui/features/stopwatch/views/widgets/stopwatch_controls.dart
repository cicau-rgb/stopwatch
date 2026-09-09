import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/view_models/stopwatch_view_model.dart';

class StopwatchControls extends StatelessWidget {
  const StopwatchControls({
    super.key,
    required this.viewModel,
  });

  final StopwatchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final isRunning = viewModel.isRunning;
    final isPaused = viewModel.isPaused;
    final isInitial = viewModel.isInitial;

    final String leftLabel;
    final VoidCallback? leftOnTap;
    final Color leftBackground;
    final Color leftTextColor;
    final Color leftBorderColor;
    final Key leftKey;

    if (isRunning) {
      leftLabel = 'Lap';
      leftOnTap = viewModel.recordLap;
      leftBackground = AppTheme.resetBackground;
      leftTextColor = AppTheme.resetAccent;
      leftBorderColor = AppTheme.surfaceElevated;
      leftKey = const Key('lap_button');
    } else if (isPaused) {
      leftLabel = 'Reset';
      leftOnTap = viewModel.reset;
      leftBackground = AppTheme.resetBackground;
      leftTextColor = AppTheme.resetAccent;
      leftBorderColor = AppTheme.surfaceElevated;
      leftKey = const Key('reset_button');
    } else {
      leftLabel = 'Lap';
      leftOnTap = null;
      leftBackground = AppTheme.surface.withValues(alpha: 0.5);
      leftTextColor = AppTheme.textMuted;
      leftBorderColor = Colors.transparent;
      leftKey = const Key('lap_button_disabled');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            key: leftKey,
            label: leftLabel,
            onTap: leftOnTap,
            backgroundColor: leftBackground,
            textColor: leftTextColor,
            borderColor: leftBorderColor,
          ),
          if (isRunning)
            _ControlButton(
              key: const Key('pause_button'),
              label: 'Pause',
              onTap: viewModel.pause,
              backgroundColor: AppTheme.pauseBackground,
              textColor: AppTheme.pauseAccent,
              borderColor: AppTheme.pauseAccent.withValues(alpha: 0.3),
            )
          else
            _ControlButton(
              key: const Key('start_button'),
              label: isInitial ? 'Start' : 'Resume',
              onTap: viewModel.start,
              backgroundColor: AppTheme.startBackground,
              textColor: AppTheme.startAccent,
              borderColor: AppTheme.startAccent.withValues(alpha: 0.3),
            ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Material(
        color: backgroundColor,
        shape: CircleBorder(
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
