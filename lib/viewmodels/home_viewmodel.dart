import 'package:flutter/material.dart';
import 'package:habify/main.dart';
import 'package:habify/models/habit.dart';
import 'package:habify/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeViewModel {
  final ValueNotifier<Box<Habit>> habitBox =
      ValueNotifier(Hive.box<Habit>('habits'));
  final ValueNotifier<Box<CustomNote>> noteBox =
      ValueNotifier(Hive.box<CustomNote>('notes'));

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning! Ready to conquer the day?";
    if (hour < 18) return "Good afternoon! Keep pushing forward!";
    return "Good evening! Time to wind down and reflect.";
  }

  Future<void> loadHabits() async {
    final box =
        await Hive.openBox<Habit>('habits'); // ✅ Open box before using it
    if (box.isEmpty) {
      print("Habit Box is empty!"); // ✅ Debugging log
    } else {
      print("Loaded ${box.length} habits");
    }
  }

  void updateHabitCompletion(int index, bool isCompleted) async {
    final box = await Hive.openBox<Habit>('habits');

    if (index >= 0 && index < box.length) {
      final habit = box.getAt(index);
      if (habit != null) {
        habit.isCompleted = isCompleted;
        await box.putAt(index, habit); // ✅ Save the updated habit

        habitBox.value = box;
        habitBox.notifyListeners();
      }
    }
  }

  void markAsSkipped(int habitIndex) async {
    final box = await Hive.openBox<Habit>('habits');

    if (habitIndex >= 0 && habitIndex < box.length) {
      final habit = box.getAt(habitIndex);

      if (habit != null) {
        habit.status = 'Skipped'; // ✅ Update habit status
        await box.putAt(habitIndex, habit); // ✅ Save updated habit

        // ✅ Show confirmation message
        if (navigatorKey.currentContext != null) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Habit marked as Skipped')),
          );
        }

        habitBox.value = Hive.box<Habit>('habits');
        habitBox.notifyListeners();
      }
    }
  }

  void deleteHabit(int habitIndex) async {
    final box = await Hive.openBox<Habit>('habits');

    if (habitIndex >= 0 && habitIndex < box.length) {
      // ✅ Prevents index error
      await box.deleteAt(habitIndex); // ✅ Delete from Hive
      habitBox.value = Hive.box<Habit>('habits');
      habitBox.notifyListeners();
    }

    // ✅ Show confirmation message
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(content: Text('Habit deleted successfully!')),
    );
  }

  void deleteNote(int noteIndex) async {
    final box = await Hive.openBox<CustomNote>('notes');

    if (noteIndex >= 0 && noteIndex < box.length) {
      // ✅ Prevents index error
      await box.deleteAt(noteIndex); // ✅ Delete from Hive
      noteBox.value = Hive.box<CustomNote>('notes'); // ✅ Reassign to notify UI
      noteBox.notifyListeners(); // ✅ Force UI refresh
    }

    // ✅ Show confirmation message
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(content: Text('Note deleted successfully!')),
    );
  }

  // void markAsSkipped(int index) {
  //   final habit = habitBox.value.getAt(index);
  //   if (habit != null) {
  //     habit.status = 'skipped';
  //     habitBox.value.putAt(index, habit);
  //   }
  // }
}
