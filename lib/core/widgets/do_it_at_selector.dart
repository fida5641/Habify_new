import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habify/viewmodels/add_viewmodel.dart';

class DoItAtSelector extends StatelessWidget {
  final AddHabitViewModel viewModel;

  const DoItAtSelector({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Do It At', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 15),
        ValueListenableBuilder<int>(
          valueListenable: viewModel.groupValue,
          builder: (context, selectedValue, _) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CupertinoSlidingSegmentedControl<int>(
                thumbColor: const Color(0xFF29068D),
                groupValue: selectedValue,
                children: {
                  0: buildSegment('Any Time'),
                  1: buildSegment('Morning'),
                  2: buildSegment('Afternoon'),
                  3: buildSegment('Evening'),
                  4: buildSegment('Night'),
                },
                onValueChanged: (newValue) {
                  if (newValue != null) {
                    viewModel.setDoItAt(newValue); // ✅ Update ViewModel value
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildSegment(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
