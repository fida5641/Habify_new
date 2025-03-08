import 'package:flutter/material.dart';
import 'package:habify/viewmodels/progress_viewmodel.dart';

class ProgressScreen extends StatelessWidget {
  final ProgressViewModel viewModel = ProgressViewModel();

  ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'STATISTICS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: viewModel.totalRunningHabits,
                      builder: (context, value, _) {
                        return statsCard("Total Running\nHabits", "$value");
                      },
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: viewModel.completedHabits,
                      builder: (context, value, _) {
                        return statsCard("Completed\nHabits", "$value");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  'MOST ACTIVE DAYS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 20),
                mostActiveDaysGraph(),
                const SizedBox(height: 30),
                Text(
                  'TODAY COMPLETION RATE',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<double>(
                  valueListenable: viewModel.completionRate,
                  builder: (context, value, _) {
                    return completionRateBar(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statsCard(String title, String value) {
    return Expanded(
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mostActiveDaysGraph() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Graph Placeholder',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ),
    );
  }

  Widget completionRateBar(double value) {
    return Container(
      height: 20,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Container(
            height: 20,
            width: value,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
