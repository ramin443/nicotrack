import 'package:flutter/material.dart';

class StyledProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 and 1.0

  const StyledProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0), // rounded corners
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: 12.0,
        backgroundColor: Colors.grey.shade100,
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8BC34A)), // green
      ),
    );
  }
}