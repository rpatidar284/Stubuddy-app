// File: lib/features/my_grades/presentation/widgets/grade_analytics_card.dart
import 'package:flutter/material.dart';
import 'package:stu_buddy/utils/constants/colors.dart'; // Assuming SColors is defined here
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart'; // Assuming SSizes is defined here

class GradeAnalyticsCard extends StatelessWidget {
  final List<Map<String, dynamic>> subjectAverageGrades;

  const GradeAnalyticsCard({Key? key, required this.subjectAverageGrades})
    : super(key: key);

  static const List<Color> _barColors = [
    Colors.lightGreen,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Explicitly set card color
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grades Analytics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildGradeBarChart(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeBarChart(BuildContext context) {
    // if (subjectAverageGrades.isEmpty) {
    //   return const SizedBox(
    //     height: 180,
    //     child: Center(child: Text('Add grades to see your performance graph!')),
    //   );
    // }

    double maxPercentage = 100.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SSizes.md),
        color: SColors.primary.withOpacity(0.1),
      ),
      // Reduced overall padding/margin for compactness
      padding: const EdgeInsets.only(
        left: 4,
        right: 4,
        bottom: 4,
        top: 4,
      ), // Adjusted padding
      margin: const EdgeInsets.all(4), // Adjusted margin
      child: Column(
        children: [
          SizedBox(
            height: 150, // Adjusted height for more compact chart
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch children vertically
              children: [
                // Y-axis labels and Percentage (%) label
                SizedBox(
                  width:
                      24, // Fixed width for Y-axis labels including rotated text
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 4.0,
                        left: 16,
                      ), // Padding to separate from numbers
                      child: Text(
                        'Percentage (%)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                  ),
                ),

                // Vertical divider line (optional, for visual separation)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ), // Reduced horizontal padding
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final actualChartHeight = constraints.maxHeight - 30;
                        final maxBarHeight =
                            actualChartHeight *
                            0.9; // Adjusted for slightly shorter bars

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(subjectAverageGrades.length, (
                            index,
                          ) {
                            final gradeData = subjectAverageGrades[index];
                            final double percentage =
                                (gradeData['averagePercentage'] ?? 0)
                                    .toDouble();
                            double barHeight =
                                (percentage / maxPercentage) * maxBarHeight;

                            final Color barColor =
                                _barColors[index % _barColors.length];

                            return Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${percentage.round()}%',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Container(
                                    height: barHeight,
                                    width:
                                        18, // Slightly reduced bar width for more horizontal space
                                    decoration: BoxDecoration(
                                      color: barColor,
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ), // Make corners rounder like example
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // X-axis subject name (horizontal) - now constrained by Flexible
                                  Text(
                                    (gradeData[DBHelper.COL_GRADE_SUB_NAME] ??
                                        'N/A'),
                                    style: const TextStyle(fontSize: 10),
                                    overflow:
                                        TextOverflow.ellipsis, // Use ellipsis
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Overall X-axis label
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Subjects',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
