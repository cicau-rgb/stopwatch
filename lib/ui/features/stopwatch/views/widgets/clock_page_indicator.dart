import 'package:flutter/material.dart';
import 'package:stopwatch_app/core/theme/app_theme.dart';

class ClockPageIndicator extends StatelessWidget {
  const ClockPageIndicator({
    super.key,
    required this.pageController,
    required this.currentPageNotifier,
    this.pageCount = 2,
  });

  final PageController pageController;
  final ValueNotifier<int> currentPageNotifier;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pageCount, (index) {
            final isSelected = currentPage == index;
            return GestureDetector(
              key: Key('page_indicator_$index'),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 8.0,
                ),
                child: Container(
                  width: isSelected ? 8.0 : 6.0,
                  height: isSelected ? 8.0 : 6.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppTheme.textPrimary
                        : AppTheme.textMuted.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
