import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';
import 'package:stopwatch_app/ui/features/stopwatch/view_models/stopwatch_view_model.dart';
import 'widgets/analog_display.dart';
import 'widgets/clock_page_indicator.dart';
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
  late final ValueNotifier<int> _currentPageNotifier;
  late final AppLifecycleListener _lifecycleListener;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPageNotifier = ValueNotifier<int>(0);
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = StopwatchViewModel();
      _ownsViewModel = true;
    }
    _lifecycleListener = AppLifecycleListener(
      onPause: _viewModel.persistCurrentState,
      onHide: _viewModel.persistCurrentState,
      onDetach: _viewModel.persistCurrentState,
      onExitRequested: () async {
        await _viewModel.persistCurrentState();
        return AppExitResponse.exit;
      },
    );
    _viewModel.restoreState();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _pageController.dispose();
    _currentPageNotifier.dispose();
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
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            SizedBox(
              height: 240.0,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPageNotifier.value = index;
                },
                children: [
                  Center(
                    child: ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, _) => DigitalDisplay(
                        minutes: _viewModel.formattedMinutes,
                        seconds: _viewModel.formattedSeconds,
                        hundredths: _viewModel.formattedHundredths,
                      ),
                    ),
                  ),
                  Center(
                    child: ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, _) {
                        final secondHandColor = _viewModel.isPaused
                            ? AppTheme.pauseAccent
                            : AppTheme.startAccent;
                        return AnalogDisplay(
                          elapsed: _viewModel.elapsed,
                          secondHandColor: secondHandColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
              child: ClockPageIndicator(
                pageController: _pageController,
                currentPageNotifier: _currentPageNotifier,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) =>
                    StopwatchControls(viewModel: _viewModel),
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) => LapListView(viewModel: _viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
