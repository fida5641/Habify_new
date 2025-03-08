import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habify/core/sized_box.dart';
import 'package:habify/viewmodels/add_viewmodel.dart';

class CounterSelector extends StatelessWidget {
  final AddHabitViewModel viewModel;

  const CounterSelector({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Set Counter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: ValueListenableBuilder<int>(
                valueListenable: viewModel.selectedNumber,
                builder: (context, selectedNumber, _) {
                  return CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: selectedNumber - 1),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) => viewModel.setSelectedNumber(index + 1),
                    children: List.generate(100, (index) => Center(child: Text('${index + 1}', style: const TextStyle(fontSize: 18, color: Colors.white)))),
                  );
                },
              ),
            ),
            AppSpacing.smallWidth,
            SizedBox(
              height: 100,
              width: 100,
              child: ValueListenableBuilder<String>(
                valueListenable: viewModel.selectedOptions,
                builder: (context, selectedOptions, _) {
                  return CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: viewModel.options.indexOf(selectedOptions)),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) => viewModel.setSelectedOption(viewModel.options[index]),
                    children: viewModel.options.map((option) => Center(child: Text(option, style: const TextStyle(fontSize: 18, color: Colors.white)))).toList(),
                  );
                },
              ),
            ),
            AppSpacing.smallWidth,
            const Text('per day', style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic, color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
