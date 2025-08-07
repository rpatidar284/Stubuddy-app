import 'package:flutter/material.dart';

class AttendanceAnalytics extends StatelessWidget {
  final List<double> weeklyData;
  final double average;
  final String bestDay;
  final double trend;

  const AttendanceAnalytics({
    super.key,
    required this.weeklyData,
    required this.average,
    required this.bestDay,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attendance Analytics",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            return Column(
              children: [
                Container(
                  height: weeklyData[index],
                  width: 10,
                  color: weeklyData[index] >= 75 ? Colors.green : Colors.orange,
                ),
                SizedBox(height: 4),
                Text(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index]),
              ],
            );
          }),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoCard(label: "${average.toInt()}%", subLabel: "Average"),
            InfoCard(label: bestDay, subLabel: "Best Day"),
            InfoCard(label: "+${trend.toInt()}%", subLabel: "Trend"),
          ],
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label, subLabel;
  const InfoCard({super.key, required this.label, required this.subLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        Text(subLabel),
      ],
    );
  }
}
