import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habify/models/habit.dart';

class ChartViewModel {
  final ValueNotifier<List<ChartData>> chartData = ValueNotifier([]);

  ChartViewModel() {
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final box = await Hive.openBox<Habit>('habits');
    final habits = box.values.toList();

    List<ChartData> data = habits.map((habit) {
      return ChartData(
        habitName: habit.name,
        completionRate: habit.isCompleted ? 100 : 0,
      );
    }).toList();

    chartData.value = data;
  }

  void dispose() {
    chartData.dispose();
  }
}

class ChartData {
  final String habitName;
  final int completionRate;

  ChartData({required this.habitName, required this.completionRate});
}
