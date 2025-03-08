import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;

  const CustomChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.grey[800],
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
