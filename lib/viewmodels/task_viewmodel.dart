import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habify/models/habit.dart';

class TaskViewModel {
  final ValueNotifier<int> swipeCount = ValueNotifier(0);
  final ValueNotifier<bool> isCompleted = ValueNotifier(false);
  final ValueNotifier<int> currentStreak = ValueNotifier(0);

  final Habit habit;
  final int habitIndex;

  TaskViewModel({required this.habit, required this.habitIndex}) {
    _loadInitialData();
  }

  void _loadInitialData() {
    swipeCount.value = 0; // Start fresh
    isCompleted.value = habit.isCompleted;
  }

  void updateSwipeCount(int count) async {
    swipeCount.value = count;
    if (swipeCount.value >= habit.selectedNumber) {
      isCompleted.value = true;
      await _saveCompletionStatus();
    }
  }

  String getSegmentLabel(int segment) {
    switch (segment) {
      case 0:
        return 'Any Time';
      case 1:
        return 'Morning';
      case 2:
        return 'Afternoon';
      case 3:
        return 'Evening';
      case 4:
        return 'Night';
      default:
        return 'Unknown';
    }
  }

  Future<void> _saveCompletionStatus() async {
    final box = await Hive.openBox<Habit>('habits');
    final storedHabit = box.getAt(habitIndex);

    if (storedHabit != null) {
      storedHabit.isCompleted = true;
      await box.putAt(habitIndex, storedHabit);
    }
  }

  void resetProgress() async {
    swipeCount.value = 0;
    isCompleted.value = false;

    final box = await Hive.openBox<Habit>('habits');
    final storedHabit = box.getAt(habitIndex);

    if (storedHabit != null) {
      storedHabit.isCompleted = false;
      await box.putAt(habitIndex, storedHabit);
    }
  }

  void dispose() {
    swipeCount.dispose();
    isCompleted.dispose();
    currentStreak.dispose();
  }
}
