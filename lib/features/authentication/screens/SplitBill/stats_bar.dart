import 'package:flutter/material.dart';

/// A reusable widget to display a labeled progress bar for stats like
/// 'Paid' or 'Owed'.
class StatsBar extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color barColor;

  const StatsBar({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row for the label and the value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // The visual progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.black.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
