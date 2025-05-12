import 'package:flutter/material.dart';
import 'package:habify/features/home/widgets/habit_item.dart';
import 'package:habify/features/home/widgets/note_item.dart';
import 'package:habify/models/habit.dart';
import 'package:habify/models/note.dart';
import 'package:habify/viewmodels/home_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ItemsListView extends StatefulWidget {
  final HomeViewModel viewModel;

  const ItemsListView({
    super.key,
    required this.viewModel,
  });

  @override
  State<ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  void _showTakeDayOffAlert(int habitIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Take a day off?'),
          content: const Text(
              'Mark this habit as "Skipped" if you have a valid reason. The skipped status will not break your streak.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final habitBox = Hive.box<Habit>('habits');
                final habit = habitBox.getAt(habitIndex);

                if (habit != null) {
                  habit.status = 'skipped';
                  habitBox.putAt(habitIndex, habit);

                  setState(() {});

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.viewModel.habitBox,
      builder: (context, Box<Habit> habitBox, _) {
        return ValueListenableBuilder(
          valueListenable: widget.viewModel.noteBox,
          builder: (context, Box<CustomNote> noteBox, _) {
            if (habitBox.isEmpty && noteBox.isEmpty) {
              return const Center(
                child: Text(
                  'What needs to be done today?',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              );
            }

            return Column(
              children: [
                // Notes section
                ...List.generate(noteBox.length, (noteIndex) {
                  final note = noteBox.getAt(noteIndex);
                  if (note == null) return const SizedBox.shrink();
                  return NoteItem(
                    note: note,
                    noteIndex: noteIndex,
                    onDelete: widget.viewModel.deleteNote,
                  );
                }),

                // Habits section
                ...List.generate(habitBox.length, (habitIndex) {
                  final habit = habitBox.getAt(habitIndex);
                  if (habit == null) return const SizedBox.shrink();
                  return HabitItem(
                    habit: habit,
                    habitIndex: habitIndex,
                    onTaskCompleted: (isCompleted) {
                      widget.viewModel.updateHabitCompletion(
                        habitIndex,
                        isCompleted,
                      );
                    },
                    onDelete: () {
                      widget.viewModel.deleteHabit(habitIndex);
                    },
                    onEdit: () {
                      Navigator.pushNamed(context, '/add', arguments: {
                        'habit': habit,
                        'habitIndex': habitIndex,
                      });
                    },
                    onSkip: () => _showTakeDayOffAlert(habitIndex),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
