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

  // Track loading state
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  // Track error states
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  HomeViewModel() {
    // Initialize data on creation
    _initializeNotes();
  }

  Future<void> _initializeNotes() async {
    isLoading.value = true;
    try {
      final box = await Hive.openBox<CustomNote>('notes');

      // Make noteBox reactive to changes
      noteBox.value = box;
      box.listenable().addListener(() {
        noteBox.notifyListeners(); // ✅ Auto update UI on changes
      });
    } catch (e) {
      errorMessage.value = "Failed to load notes: $e";
    } finally {
      isLoading.value = false;
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning! Ready to conquer the day?";
    if (hour < 18) return "Good afternoon! Keep pushing forward!";
    return "Good evening! Time to wind down and reflect.";
  }

  Future<void> loadHabits() async {
    final box = await Hive.openBox<Habit>('habits');
    if (box.isEmpty) {
      print("Habit Box is empty!");
    } else {
      print("Loaded ${box.length} habits");
    }

    // Ensure our valueNotifier is updated
    habitBox.value = box;
    habitBox.notifyListeners();
  }

  void updateHabitCompletion(int index, bool isCompleted) async {
    isLoading.value = true;

    try {
      final box = await Hive.openBox<Habit>('habits');

      if (index >= 0 && index < box.length) {
        final habit = box.getAt(index);
        if (habit != null) {
          habit.isCompleted = isCompleted;
          await box.putAt(index, habit);

          habitBox.value = box;
          habitBox.notifyListeners();
        }
      }
    } catch (e) {
      errorMessage.value = "Failed to update habit: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void markAsSkipped(int habitIndex) async {
    isLoading.value = true;

    try {
      final box = await Hive.openBox<Habit>('habits');

      if (habitIndex >= 0 && habitIndex < box.length) {
        final habit = box.getAt(habitIndex);

        if (habit != null) {
          habit.status = 'skipped';
          await box.putAt(habitIndex, habit);

          // Show confirmation message
          if (navigatorKey.currentContext != null) {
            ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              const SnackBar(content: Text('Habit marked as Skipped')),
            );
          }

          habitBox.value = box;
          habitBox.notifyListeners();
        }
      }
    } catch (e) {
      errorMessage.value = "Failed to mark habit as skipped: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void deleteHabit(int habitIndex) async {
    isLoading.value = true;

    try {
      final box = await Hive.openBox<Habit>('habits');

      if (habitIndex >= 0 && habitIndex < box.length) {
        await box.deleteAt(habitIndex);

        // habitBox.value = box;
        habitBox.notifyListeners();
      }

      // Show confirmation message
      if (navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Habit deleted successfully!')),
        );
      }
    } catch (e) {
      errorMessage.value = "Failed to delete habit: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote(CustomNote note) async {
    isLoading.value = true;
    try {
      final box = await Hive.openBox<CustomNote>('notes');
      await box.add(note);

      // Update noteBox value and notify listeners
      noteBox.value = box;
      noteBox.notifyListeners(); // ✅ Forces UI update
    } catch (e) {
      errorMessage.value = "Failed to add note: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNote(int noteIndex) async {
    isLoading.value = true;
    try {
      final box = await Hive.openBox<CustomNote>('notes');

      if (noteIndex >= 0 && noteIndex < box.length) {
        await box.deleteAt(noteIndex);

        // Update noteBox value and notify listeners
        noteBox.value = box;
        noteBox.notifyListeners(); // ✅ Forces UI update
      }

      // Show confirmation message
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted successfully!')),
        );
      }
    } catch (e) {
      errorMessage.value = "Failed to delete note: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
