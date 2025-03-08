import 'package:flutter/material.dart';
import 'package:habify/viewmodels/add_viewmodel.dart';

class HabitSelection extends StatelessWidget {
  final AddHabitViewModel viewModel;

  const HabitSelection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
   return ValueListenableBuilder<String?>(
  valueListenable: viewModel.selectedHabit,
  builder: (context, selectedHabit, _) {
    return DropdownButtonFormField<String>(
      value: viewModel.habitOptions.any((habit) => habit['name'] == selectedHabit)
          ? selectedHabit // ✅ Use only if it exists
          : null, // ✅ Keeps null until the user selects

      hint: const Text('Select Habit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromARGB(95, 156, 152, 140))),

      onChanged: (value) => viewModel.selectedHabit.value = value!, // ✅ Updates habit
       dropdownColor: Colors.black,
       style: TextStyle(color: Colors.white),
      items: viewModel.habitOptions.map((habit) {
        return DropdownMenuItem<String>(
          value: habit['name'],
          child: Row(
            children: [
              Image.asset(habit['image']!, width: 30, height: 30),
              const SizedBox(width: 10),
              Text(habit['name']!),
            ],
          ),
        );
      }).toList(),
    );
  },
);

  }
}
