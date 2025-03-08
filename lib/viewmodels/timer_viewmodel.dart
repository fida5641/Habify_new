import 'package:flutter/material.dart';

class TimerViewModel {
  final ValueNotifier<int> currentTime = ValueNotifier(300);
  final ValueNotifier<bool> isRunning = ValueNotifier(false);
  int duration = 5;
  late final Stopwatch stopwatch;

  TimerViewModel() {
    stopwatch = Stopwatch();
  }

  void startTimer() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
      isRunning.value = true;
      _updateTimer();
    }
  }

  void restartTimer() {
    stopwatch.reset();
    currentTime.value = duration * 60;
    isRunning.value = false;
  }

  void _updateTimer() async {
    while (stopwatch.isRunning) {
      await Future.delayed(const Duration(seconds: 1));
      currentTime.value = duration * 60 - stopwatch.elapsed.inSeconds;
      if (currentTime.value <= 0) {
        stopwatch.reset();
        isRunning.value = false;
        break;
      }
    }
  }
}
