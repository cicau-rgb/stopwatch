import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/view_models/stopwatch_view_model.dart';
import 'widgets/analog_display.dart';
import 'widgets/digital_display.dart';
import 'widgets/lap_list_view.dart';
import 'widgets/stopwatch_controls.dart';

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
  late final PageController _pageController;
  bool _ownsViewModel = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = StopwatchViewModel();
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            final secondHandColor = _viewModel.isPaused
                ? AppTheme.pauseAccent
                : AppTheme.startAccent;

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 8.0),
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
                SizedBox(
                  height: 240.0,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      Center(
                        child: DigitalDisplay(
                          minutes: _viewModel.formattedMinutes,
                          seconds: _viewModel.formattedSeconds,
                          hundredths: _viewModel.formattedHundredths,
                        ),
                      ),
                      Center(
                        child: AnalogDisplay(
                          elapsed: _viewModel.elapsed,
                          secondHandColor: secondHandColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      final isSelected = _currentPage == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: isSelected ? 8.0 : 6.0,
                        height: isSelected ? 8.0 : 6.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.textPrimary
                              : AppTheme.textMuted.withValues(alpha: 0.5),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: StopwatchControls(viewModel: _viewModel),
                ),
                Expanded(
                  child: LapListView(viewModel: _viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
