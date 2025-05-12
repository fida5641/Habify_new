import 'package:flutter/material.dart';
import 'package:habify/features/tasks/tas_screen.dart';
import 'package:habify/models/habit.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final int habitIndex;
  final Function(bool) onTaskCompleted;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSkip;

  const HabitItem({
    super.key,
    required this.habit,
    required this.habitIndex,
    required this.onTaskCompleted,
    required this.onDelete,
    required this.onEdit,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            habit.image.isNotEmpty
                ? Image.asset(
                    habit.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
            const SizedBox(width: 10),
            ValueListenableBuilder(
                valueListenable: Hive.box<Habit>('habits').listenable(),
                builder: (context, Box<Habit> box, _) {
                  final updatedHabit = box.getAt(habitIndex);

                  if (updatedHabit == null) {
                    return SizedBox(); // Return an empty widget if habit is null
                  }

                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: habit.isCompleted ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: habit.isCompleted ? Colors.green : Colors.black,
                    ),
                    child: InkWell(
                      onTap: () async {
                        final isCompleted = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskScreen(
                              habit: habit,
                              habitIndex: habitIndex,
                              
                            ),
                          ),
                        );
                        // ✅ Check if the task was completed and update UI
                        if (isCompleted != null) {
                          updatedHabit.isCompleted = isCompleted;
                          habit.status =
                              isCompleted ? 'finished' : updatedHabit.status;
                          box.putAt(habitIndex, habit);
                          onTaskCompleted(isCompleted);
                        }
                      },
                      child: updatedHabit.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                }),
          ],
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: habit.status == 'skipped'
                ? Colors.grey
                : (habit.isCompleted ? Colors.white : Colors.white),
          ),
        ),
        subtitle: Text(
          habit.status == 'skipped'
              ? 'Skipped'
              : (habit.isCompleted ? 'Finished' : ''),
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.black,
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            } else if (value == 'skip') {
              onSkip();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
                value: 'edit',
                child: Text('Edit', style: TextStyle(color: Colors.white))),
            const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.white))),
            const PopupMenuItem(
                value: 'skip',
                child: Text('Take day off',
                    style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
