import 'package:flutter/material.dart';
import 'package:habify/core/sized_box.dart';
import 'package:habify/viewmodels/add_viewmodel.dart';

class DaySelector extends StatelessWidget {
  final AddHabitViewModel viewModel;

  const DaySelector({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        AppSpacing.small,
        ValueListenableBuilder<List<String>>(
          valueListenable: viewModel.selectedDays,
          builder: (context, selected, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: viewModel.daysOfWeek.map((day) {
                return GestureDetector(
                  onTap: () => viewModel.toggleDay(day),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: selected.contains(day) ? const Color(0xFF29068D) : Colors.white10,
                        child: Text(
                          day[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // const SizedBox(height: 5),
                      Text(day, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
