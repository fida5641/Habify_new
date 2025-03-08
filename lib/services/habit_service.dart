import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class HabitService {
  final ValueNotifier<List<Habit>> habits = ValueNotifier([]);

  HabitService() {
    loadHabits();
  }

  Future<void> addHabit(Habit habit) async {
    final box = Hive.box<Habit>('habits');
    await box.add(habit);
    loadHabits(); // Refresh UI
  }

  void loadHabits() {
    final box = Hive.box<Habit>('habits');
    habits.value = box.values.toList();
  }

  Future<void> updateHabit(int index, Habit updatedHabit) async {
    final box = Hive.box<Habit>('habits');
    await box.putAt(index, updatedHabit);
    loadHabits(); // Refresh UI
  }

  Future<void> deleteAllHabits() async {
    final box = Hive.box<Habit>('habits');
    await box.clear();
    loadHabits(); // Refresh UI
  }
}
