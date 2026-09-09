import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/features/stopwatch/views/stopwatch_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const StopwatchScreen(),
    );
  }
}
