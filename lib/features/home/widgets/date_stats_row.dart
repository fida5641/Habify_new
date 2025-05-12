import 'package:flutter/material.dart';

class DateStatsRow extends StatelessWidget {
  final String currentDay;
  final String currentDate;
  final double taskCompletionPercentage;

  const DateStatsRow({
    super.key,
    required this.currentDay,
    required this.currentDate,
    required this.taskCompletionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                '${taskCompletionPercentage.toStringAsFixed(1)}% done',
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const Text('Completed Tasks',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}