import 'package:flutter/material.dart';
import 'package:habify/viewmodels/chart_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatelessWidget {
  final ChartViewModel viewModel = ChartViewModel();

  ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Habit Progress Charts"),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Habit Completion Rate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<List<ChartData>>(
                valueListenable: viewModel.chartData,
                builder: (context, data, _) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        "No data available",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }
                  return SfCartesianChart(
  primaryXAxis: CategoryAxis(),
  series: <CartesianSeries<dynamic, dynamic>>[  // ✅ Fix applied here
    ColumnSeries<ChartData, String>(
      dataSource: data,
      xValueMapper: (ChartData habit, _) => habit.habitName,
      yValueMapper: (ChartData habit, _) => habit.completionRate,
      color: Colors.blue,
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    )
  ],
);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
