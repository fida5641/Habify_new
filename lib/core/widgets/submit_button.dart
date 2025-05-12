import 'package:flutter/material.dart';
import 'package:habify/viewmodels/add_viewmodel.dart';

class SubmitButton extends StatelessWidget {
  final AddHabitViewModel viewModel;
  final int? habitIndex; // ✅ Receives habitIndex

  const SubmitButton({super.key, required this.viewModel, this.habitIndex});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.isLoading,
      builder: (context, isLoading, _) {
        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  if (habitIndex != null) {
                    viewModel.updateHabit(
                        context, habitIndex!); // ✅ Update if editing
                  } else {
                    viewModel.saveHabit(context); // ✅ Save if new
                  }
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
            backgroundColor: const Color(0xFF29068D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(habitIndex != null ? 'Update' : 'Submit',
                  style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
