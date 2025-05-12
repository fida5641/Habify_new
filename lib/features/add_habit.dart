import 'package:flutter/material.dart';
import 'package:habify/core/sized_box.dart';
import 'package:habify/core/widgets/counter_selector.dart';
import 'package:habify/core/widgets/day_selector.dart';
import 'package:habify/core/widgets/do_it_at_selector.dart';
import 'package:habify/core/widgets/habit_selection.dart';
import 'package:habify/core/widgets/submit_button.dart';
import 'package:habify/models/habit.dart';
import 'package:habify/viewmodels/add_viewmodel.dart';
import '../core/constant.dart';

class AddScreen extends StatefulWidget {
  final Habit? habit;
  final int? habitIndex;
  final String username;
  const AddScreen(
      {super.key, required this.username, this.habit, this.habitIndex});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late AddHabitViewModel _viewModel;

@override
void initState() {
  super.initState();
  _viewModel = AddHabitViewModel();

  if (widget.habit != null && widget.habit != null) { // ✅ Only load if editing a habit
    _viewModel.selectedHabit.value = widget.habit!.name;
    _viewModel.targetController.text = widget.habit!.target.toString();
    _viewModel.selectedDays.value = List<String>.from(widget.habit!.days);
    _viewModel.groupValue.value = widget.habit!.segment;
    _viewModel.selectedOptions.value = widget.habit!.selectedOptions;
    _viewModel.selectedNumber.value = widget.habit!.selectedNumber;
  }
}

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ScreenStyle(),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              Padding(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                      child: Text(widget.habitIndex != null ? 'Edit Habit' : 'Start your Habit',
                      style: titleStyle))),
              HabitSelection(viewModel: _viewModel), // ✅ Habit selection
              if (_viewModel.selectedHabit.value == 'Other')
                TextField(
                    controller: _viewModel.otherHabitController,
                    decoration:
                        const InputDecoration(labelText: 'Enter Habit')),
              TextField(
                keyboardType: TextInputType.number,
                  controller: _viewModel.targetController,
                  decoration: const InputDecoration(labelText: 'Target Days',)),
              AppSpacing.medium,
              DaySelector(viewModel: _viewModel),
              AppSpacing.medium, // ✅ Select Days
              CounterSelector(viewModel: _viewModel),
              AppSpacing.medium,
              DoItAtSelector(
                  viewModel: _viewModel), // ✅ Added "Do It At" Selector
                  AppSpacing.large,

              Center(
                child: SubmitButton(
                  viewModel: _viewModel,
                  habitIndex: widget
                      .habitIndex, // ✅ Pass habitIndex instead of widget.habit!.habitIndex
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
