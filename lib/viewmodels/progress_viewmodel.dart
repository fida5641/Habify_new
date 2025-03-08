import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habify/models/habit.dart';

class ProgressViewModel {
  final ValueNotifier<int> totalRunningHabits = ValueNotifier(0);
  final ValueNotifier<int> completedHabits = ValueNotifier(0);
  final ValueNotifier<double> completionRate = ValueNotifier(0.0);

  ProgressViewModel() {
    _loadStats();
  }

  Future<void> _loadStats() async {
    final box = await Hive.openBox<Habit>('habits');
    final habits = box.values.toList();

    totalRunningHabits.value = habits.length;
    completedHabits.value = habits.where((habit) => habit.isCompleted).length;
    completionRate.value = totalRunningHabits.value == 0
        ? 0.0
        : (completedHabits.value / totalRunningHabits.value) * 100;
  }

  void dispose() {
    totalRunningHabits.dispose();
    completedHabits.dispose();
    completionRate.dispose();
  }
}
