import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:habify/features/tasks/tas_screen.dart';
import 'package:habify/models/habit.dart';
import 'package:habify/models/note.dart';
import 'package:habify/services/note_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  final int? habitIndex;
  final String username;
  final double taskCompletionPercentage;

  const HomeScreen(
      {super.key,
      required this.username,
      required this.taskCompletionPercentage,
      this.habitIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService _noteService = NoteService();
  final HomeViewModel _viewModel = HomeViewModel();

  void _showTakeDayOffAlert(int habitIndex) {
    // ✅ Accepts habitIndex
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
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    final currentDate = DateFormat('dd - MMM - yyyy').format(DateTime.now());
    final greeting = _viewModel.getGreeting();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/image 1 (1).png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Text(
                        'Hello, \n${widget.username ?? 'Guest'} ',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Image.asset('assets/images/calender.png',
                          width: 100, height: 100),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                greeting,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.lightBlue, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Today's",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text('$currentDay\n$currentDate',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.taskCompletionPercentage.toStringAsFixed(1)}% done',
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text('Completed Tasks',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: _viewModel.habitBox,
              builder: (context, Box<Habit> habitBox, _) {
                return ValueListenableBuilder(
                  valueListenable: _viewModel.noteBox,
                  builder: (context, Box<CustomNote> notes, _) {
                    if (habitBox.isEmpty && notes.isEmpty) {
                      return const Center(
                        child: Text(
                          'What needs to be done today?',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        ...List.generate(habitBox.length + notes.length,
                            (int index) {
                          if (index < notes.length) {
                            final note = notes.getAt(index);
                            if (note == null) return const SizedBox.shrink();

                            return Card(
                              color: Colors.grey[850],
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: ListTile(
                                title: Text(note.title,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 20)),
                                subtitle: Text(note.content,
                                    style:
                                        const TextStyle(color: Colors.white54)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white),
                                  onPressed: () => _viewModel.deleteNote(index),
                                ),
                              ),
                            );
                          } else {
                            final habitIndex = index - notes.length;
                            final habit = habitBox.getAt(habitIndex);
                            if (habit == null) return const SizedBox.shrink();

                            return Card(
                              color: Colors.black45,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
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
                                        valueListenable:
                                            Hive.box<Habit>('habits')
                                                .listenable(),
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
                                                color: habit.isCompleted
                                                    ? Colors.green
                                                    : Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: habit.isCompleted
                                                  ? Colors.green
                                                  : Colors.black,
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                final isCompleted =
                                                    await Navigator.push<bool>(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskScreen(
                                                      habit: habit,
                                                      habitIndex: habitIndex,
                                                    ),
                                                  ),
                                                );
                                                // ✅ Check if the task was completed and update UI
                                                if (isCompleted != null) {
                                                  updatedHabit.isCompleted =
                                                      isCompleted;
                                                  habit.status = isCompleted
                                                      ? 'finished'
                                                      : updatedHabit.status;
                                                  box.putAt(habitIndex, habit);
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
                                        : (habit.isCompleted
                                            ? Colors.white
                                            : Colors.white),
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
                                      Navigator.pushNamed(context, '/add',
                                          arguments: {
                                            'habit': habit,
                                            'habitIndex': habitIndex,
                                          });
                                    } else if (value == 'delete') {
                                      _viewModel.deleteHabit(habitIndex);
                                    } else if (value == 'skip') {
                                      _showTakeDayOffAlert(habitIndex);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    const PopupMenuItem(
                                        value: 'skip',
                                        child: Text('Take day off',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
