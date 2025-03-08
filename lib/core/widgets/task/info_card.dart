import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final ValueNotifier<int> finished; // ✅ Use ValueNotifier<int>
  final int target;
  final bool isStreak;

  const InfoCard({
    super.key,
    required this.label,
    required this.finished,
    required this.target,
    this.isStreak = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Text(
            'FINISHED',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          ValueListenableBuilder(
            valueListenable: finished,
            builder: (context, count,_) => 
             Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            
          ),
          const SizedBox(height: 8),
          Text(
            isStreak ? 'Best: $target' : 'Target: $target',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
