import 'package:flutter/material.dart';
import 'package:habify/features/home/widgets/date_stats_row.dart';
import 'package:habify/features/home/widgets/greeting_header.dart';
import 'package:habify/features/home/widgets/items_list_view.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  final int? habitIndex;
  final String username;
  final double taskCompletionPercentage;

  const HomeScreen({
    super.key,
    required this.username,
    required this.taskCompletionPercentage,
    this.habitIndex,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel _viewModel = HomeViewModel();

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
            // User greeting header with background image
            GreetingHeader(username: widget.username ?? 'Guest'),
            
            // Greeting message
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                greeting,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.lightBlue, fontWeight: FontWeight.w600),
              ),
            ),
            
            // Date and task completion stats row
            DateStatsRow(
              currentDay: currentDay,
              currentDate: currentDate,
              taskCompletionPercentage: widget.taskCompletionPercentage,
            ),
            
            const SizedBox(height: 20),
            
            // Lists of notes and habits
            ItemsListView(
              viewModel: _viewModel,
            ),
          ],
        ),
      ),
    );
  }
}