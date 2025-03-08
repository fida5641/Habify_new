import 'package:flutter/material.dart';
import 'package:habify/features/add_habit.dart';
import 'package:habify/features/analyse/analyse_screen.dart';
import 'package:habify/features/chart/chart_screen.dart';
import 'package:habify/features/stopwatch/stopwatch_screen.dart';
import 'package:habify/features/tasks/progress_screen.dart';
import 'package:habify/features/tasks/tas_screen.dart';
import 'package:habify/features/timer/timer_screen.dart';
import 'package:habify/views/bottom_nav.dart';
import 'package:habify/views/home.dart';
import 'package:habify/views/log_in.dart';
import 'package:habify/views/profile.dart';
import 'package:habify/views/splash.dart';

const String homeRoute = '/';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/login': (context) => const LogScreen(),
  '/bottom_nav': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    return BottomNav(username: args?['username'] ?? 'Guest');
  },
  '/home': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    return HomeScreen(
      username: args?['username'] ?? 'Guest',
      taskCompletionPercentage: args?['taskCompletionPercentage'] ?? 0.0,
    );
  },
  '/add': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    return AddScreen(
      username: args?['username'] ?? 'Guest',
      habit: args?['habit'],
      habitIndex: args?['habitIndex'],
    );
  },
  '/task': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    return TaskScreen(
      habit: args?['habit'],
      habitIndex: args?['habitIndex'] ?? 0,
    );
  },
  '/analyse': (context) => AnalyseScreen(),
  '/stopwatch': (context) => StopwatchScreen(),
  '/timer': (context) => TimerScreen(),
  '/profile': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    return ProfileScreen(username: args?['username'] ?? 'Guest');
  },
  '/progress': (context) => ProgressScreen(),
  '/chart': (context) => ChartScreen(),
};
