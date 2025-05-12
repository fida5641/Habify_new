import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class AddHabitViewModel {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final TextEditingController habitNameController = TextEditingController();
  final TextEditingController otherHabitController = TextEditingController();
  final TextEditingController targetController = TextEditingController();

  final ValueNotifier<List<String>> selectedDays = ValueNotifier([]);
  final ValueNotifier<int> selectedNumber = ValueNotifier(1);
  final ValueNotifier<String> selectedOptions = ValueNotifier('Hours');
  final ValueNotifier<int> groupValue = ValueNotifier(0);
  final ValueNotifier<String> selectedHabit = ValueNotifier(''); // ✅ Non-nullable

  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<String> options = [
    'Hours',
    'Minutes',
    'Pages',
    'Liter',
    'Meter',
    'Cups'
  ];
  final List<String> doItAtOptions = [
    'Any Time',
    'Morning',
    'Afternoon',
    'Evening',
    'Night'
  ];

  final List<Map<String, String>> habitOptions = [
    {'name': 'Wakeup', 'image': 'assets/images/wakeup.png'},
    {'name': 'Drink Water', 'image': 'assets/images/drink water.png'},
    {'name': 'Self Care', 'image': 'assets/images/selfcare.png'},
    {'name': 'Morning Routine', 'image': 'assets/images/morning routine.png'},
    {'name': 'To-Do Planning', 'image': 'assets/images/to_do plan.png'},
    {'name': 'Workout', 'image': 'assets/images/workout.png'},
    {'name': 'Reading', 'image': 'assets/images/reading.png'},
    {'name': 'Socializing', 'image': 'assets/images/socializing.png'},
    {'name': 'Screen Time', 'image': 'assets/images/limit screen time.png'},
    {'name': 'Sleep', 'image': 'assets/images/sleep.png'},
    {'name': 'Other', 'image': 'assets/images/default.png'},
  ];

  /// ✅ **Toggle selected days**
  void toggleDay(String day) {
    final newList = List<String>.from(selectedDays.value);
    if (newList.contains(day)) {
      newList.remove(day);
    } else {
      newList.add(day);
    }
    selectedDays.value = newList;
  }

  /// ✅ **Set selected values**
  void setSelectedNumber(int number) => selectedNumber.value = number;
  void setSelectedOption(String option) => selectedOptions.value = option;
  void setSelectedHabit(String habit) => selectedHabit.value = habit;
  void setDoItAt(int value) => groupValue.value = value;

  /// ✅ **Save new habit**
  Future<void> saveHabit(BuildContext context) async {
    if (selectedHabit.value.isEmpty || targetController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final int? targetValue = int.tryParse(targetController.text);
    if (targetValue == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid target number')));
      return;
    }
    

    isLoading.value = true;

    final habit = Habit(
      name: selectedHabit.value == 'Other'
          ? otherHabitController.text
          : selectedHabit.value, // ✅ Handles "Other Habit"
      image: habitOptions.firstWhere(
          (habit) => habit['name'] == selectedHabit.value,
          orElse: () => {'image': 'assets/images/default.png'})['image']!,
      target: targetValue,
      status: '',
      days: selectedDays.value,
      segment: groupValue.value,
      selectedNumber: selectedNumber.value,
      selectedOptions: selectedOptions.value,
    );

    final box = await Hive.openBox<Habit>('habits');
    await box.add(habit);

    isLoading.value = false;
    Navigator.pushReplacementNamed(
        context, '/bottom_nav'); // ✅ Navigates after saving

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit saved successfully!')));
  }

  Future<void> updateHabit(BuildContext context, int habitIndex) async {
    final box = await Hive.openBox<Habit>('habits');

    if (habitIndex >= 0 && habitIndex < box.length) {
      // ✅ Prevents index error
      final habitKey = box.keyAt(habitIndex); // ✅ Get correct key from Hive

      final updatedHabit = Habit(
        name: selectedHabit.value!,
        image: habitOptions.firstWhere(
            (habit) => habit['name'] == selectedHabit.value,
            orElse: () => {'image': 'assets/images/default.png'})['image']!,
        target: int.tryParse(targetController.text) ?? 0,
        days: selectedDays.value,
        segment: groupValue.value,
        selectedNumber: selectedNumber.value,
        selectedOptions: selectedOptions.value,
        status: '',
      );

      await box.put(habitKey, updatedHabit); // ✅ Use correct key to update

      isLoading.value = false;
      Navigator.pushReplacementNamed(context, '/bottom_nav');

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit updated successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Habit does not exist!')));
    }
  }

  /// ✅ **Handle button action (Save or Update)**
  void handleHabitAction(BuildContext context, {int? habitIndex}) {
    if (isLoading.value) return;

    isLoading.value = true;
    if (habitIndex != null) {
      updateHabit(context, habitIndex);
    } else {
      saveHabit(context);
    }
  }

  void dispose() {
    habitNameController.dispose();
    otherHabitController.dispose();
    targetController.dispose();
    isLoading.dispose();
    selectedDays.dispose();
    selectedNumber.dispose();
    selectedOptions.dispose();
    groupValue.dispose();
    selectedHabit.dispose();
  }
}
