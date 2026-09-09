import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/view_models/stopwatch_view_model.dart';
import 'widgets/digital_display.dart';
import 'widgets/stopwatch_controls.dart';

/// Main screen for the minimalist stopwatch.
class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({
    super.key,
    this.viewModel,
  });

  final StopwatchViewModel? viewModel;

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late final StopwatchViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = StopwatchViewModel();
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Column(
              children: [
                // Top App Bar / Header
                const Padding(
                  padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
                  child: Text(
                    'STOPWATCH',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),

                // Center Digital Time Display
                Expanded(
                  child: Center(
                    child: DigitalDisplay(
                      minutes: _viewModel.formattedMinutes,
                      seconds: _viewModel.formattedSeconds,
                      hundredths: _viewModel.formattedHundredths,
                    ),
                  ),
                ),

                // Bottom Action Controls
                Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: StopwatchControls(viewModel: _viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
