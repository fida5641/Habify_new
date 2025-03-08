import 'package:flutter/material.dart';

class StopwatchViewModel {
  final Stopwatch stopwatch = Stopwatch();
  final ValueNotifier<String> formattedTime = ValueNotifier("00:00:00");

  void start() {
    stopwatch.start();
    _updateTime();
  }

  void pause() {
    stopwatch.stop();
  }

  void reset() {
    stopwatch.reset();
    formattedTime.value = "00:00:00";
  }

  void _updateTime() async {
    while (stopwatch.isRunning) {
      await Future.delayed(const Duration(milliseconds: 100));
      formattedTime.value = _formatTime(stopwatch.elapsedMilliseconds);
    }
  }

  String _formatTime(int milliseconds) {
    int seconds = (milliseconds ~/ 1000);
    int minutes = (seconds ~/ 60);
    int hours = (minutes ~/ 60);
    return '${hours.toString().padLeft(2, '0')}:'
           '${(minutes % 60).toString().padLeft(2, '0')}:'
           '${(seconds % 60).toString().padLeft(2, '0')}';
  }
}
