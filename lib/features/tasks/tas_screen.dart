import 'package:flutter/material.dart';
import 'package:habify/core/widgets/task/card_row.dart';
import 'package:habify/core/widgets/task/chip.dart';
import 'package:habify/core/widgets/task/info_card.dart';
import 'package:habify/core/widgets/task/toggled_button.dart';
import 'package:habify/features/add_habit.dart';
import 'package:habify/features/analyse/analyse_screen.dart';
import 'package:habify/features/stopwatch/stopwatch_screen.dart';
import 'package:habify/features/timer/timer_screen.dart';
import 'package:habify/models/habit.dart';
import 'package:habify/viewmodels/task_viewmodel.dart';
import 'package:habify/core/constant.dart';
import 'package:lottie/lottie.dart';

class TaskScreen extends StatefulWidget {
  final Habit habit;
  final int habitIndex; // ✅ Required parameter added

  const TaskScreen({super.key, required this.habit, required this.habitIndex});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TaskViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TaskViewModel(habit: widget.habit, habitIndex: widget.habitIndex);
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Image.asset(widget.habit.image, height: 150)),
                    const SizedBox(height: 20),
                    Text(
                      widget.habit.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomChip(label: _viewModel. getSegmentLabel(widget.habit.segment)),
                        const SizedBox(width: 10),
                        CustomChip(label: widget.habit.days.length == 7 ? "Every Day" : 'Mixed Days'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoCard(label: widget.habit.selectedOptions, finished: _viewModel.swipeCount, target: widget.habit.selectedNumber),
                        InfoCard(label: 'DAYS', finished: ValueNotifier(0), target: widget.habit.target),
                        InfoCard(label: 'CURRENT', finished: ValueNotifier(0), target: 5, isStreak: true),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<bool>(
                      valueListenable: _viewModel.isCompleted,
                      builder: (context, isCompleted, _) {
                        return isCompleted
                            ? Column(
                                children: [
                                  const Text("Congratulations! You've completed your daily habit.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white)),
                                  const SizedBox(height: 10),
                                  Lottie.asset('assets/success.json', width: 150, height: 150, repeat: true),
                                  const SizedBox(height: 10),
                                  const Text("See you tomorrow", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              )
                            : Column(
                                children: [
                                  ValueListenableBuilder<int>(
                                    valueListenable: _viewModel.swipeCount,
                                    builder: (context, swipeCount, _) {
                                      return ToggledButton(
                                        label: 'Complete one Lap',
                                        swipeCount: swipeCount,
                                        isCompleted: isCompleted,
                                        onSwipeUpdate: _viewModel.updateSwipeCount,
                                        maxSwipes: widget.habit.selectedNumber,
                                        onCompleted: () => _viewModel.updateSwipeCount(widget.habit.selectedNumber), // ✅ Ensure completion logic

                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  ToggledButton(
                                    label: 'Finish all Laps',
                                    swipeCount: widget.habit.selectedNumber,
                                    isCompleted: isCompleted,
                                    onCompleted: () => _viewModel.updateSwipeCount(widget.habit.selectedNumber),
                                    maxSwipes: widget.habit.selectedNumber,
                                    onSwipeUpdate: _viewModel.updateSwipeCount, // ✅ Added missing parameter
                                  ),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardRow(text: 'Timer', icon: Icons.timer, targetScreen: TimerScreen()),
                        CardRow(text: 'Analyse', icon: Icons.analytics, targetScreen: AnalyseScreen()),
                        CardRow(text: 'Stopwatch', icon: Icons.timer_off, targetScreen: StopwatchScreen()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 30,
            child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'reset') {
                  _viewModel.resetProgress();
                } else if (value == 'edit') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen(habit: widget.habit, habitIndex: widget.habitIndex, username: '')));
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(value: 'reset', child: Text('Reset')),
                const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
