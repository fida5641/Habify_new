import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ToggledButton extends StatelessWidget {
  final String label;
  final int swipeCount;
  final int maxSwipes;
  final bool isCompleted;
  final Function(int) onSwipeUpdate;
  final VoidCallback onCompleted;

  const ToggledButton({
    super.key,
    required this.label,
    required this.swipeCount,
    required this.maxSwipes,
    required this.isCompleted,
    required this.onSwipeUpdate,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      text: isCompleted
          ? 'Completed!'
          : '$label ($swipeCount/$maxSwipes)',
      outerColor: isCompleted ? Colors.green : Colors.grey[900],
      innerColor: isCompleted ? Colors.green : Colors.deepOrange,
      onSubmit: () {
        if (!isCompleted) {
          if (swipeCount + 1 >= maxSwipes) {
            onCompleted();
          } else {
            onSwipeUpdate(swipeCount + 1);
          }
        }
      },
      child: isCompleted
          ? Lottie.asset('assets/success.json', width: 80, height: 100, repeat: false)
          : const Icon(Icons.arrow_forward, color: Colors.white, size: 40),
    );
  }
}
