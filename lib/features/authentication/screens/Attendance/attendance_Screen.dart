import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/sprimary_header_container.dart';
import 'package:stu_buddy/common/widgets/custom_shape/curved_shap/subjectCircular.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/add_subject_view.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_analytics_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_history.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/daily_attendance_data.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_controller.dart'; // Import AttendanceController
import 'package:getwidget/getwidget.dart';

class AttendanceTrackingView extends StatelessWidget {
  AttendanceTrackingView({super.key});

  final SubjectController subjectController = Get.put(SubjectController());
  final AttendanceAnalyticsController analyticsController =
      Get.find<AttendanceAnalyticsController>();
  final AttendanceController attendanceController =
      Get.find<AttendanceController>(); // Get AttendanceController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SprimaryHeaderContainer(height: 180),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Text(
                      'Attendance Tracking',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.apply(color: SColors.white),
                    ),
                  ],
                ),
                Icon(Iconsax.graph, color: Colors.white),
              ],
            ),
          ),
          Obx(() {
            return Column(
              children: [
                SizedBox(height: 100),
                // Low Attendance Alert
                if (subjectController.lowAttendanceCount.value > 0)
                  _buildLowAttendanceAlert(),

                // Attendance Analytics Bar Chart and Metrics
                _buildAttendanceAnalyticsSection(context),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(Icons.subject),
                        SizedBox(width: SSizes.sm),
                        Text(
                          "All Subjects (${subjectController.subjects.length})",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 80.0,
                    ), // Give space for FAB
                    itemCount: subjectController.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjectController.subjects[index];
                      return Dismissible(
                        key: Key(
                          subject.id.toString(),
                        ), // Unique key for Dismissible
                        direction:
                            DismissDirection
                                .endToStart, // Swipe left-to-right to delete
                        background: Container(
                          color:
                              Colors
                                  .red
                                  .shade600, // Background color when swiping
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (subject.id == null)
                            return false; // Should not happen

                          final int recordCount = await attendanceController
                              .getAttendanceRecordCountForSubject(subject.id!);

                          if (recordCount > 0) {
                            // NEW LOGIC: Subject has history, disallow direct delete, prompt to clean history
                            return await Get.dialog<bool>(
                                  AlertDialog(
                                    title: const Text(
                                      "Cannot Delete Subject",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      "Subject '${subject.name}' has $recordCount attendance records. Please delete its attendance history first.",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed:
                                            () => Get.back(
                                              result: false,
                                            ), // Dismiss dialog, do not delete
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      GFButton(
                                        onPressed: () {
                                          Get.back(
                                            result: false,
                                          ); // Dismiss dialog, do not delete subject
                                          Get.to(
                                            () => AttendanceHistoryView(
                                              subject: subject,
                                            ),
                                          ); // Navigate to history
                                        },
                                        text: "View History",
                                        shape: GFButtonShape.pills,
                                        color: SColors.buttonPrimary,
                                        size: GFSize.MEDIUM,
                                      ),
                                    ],
                                  ),
                                ) ??
                                false; // Ensure a boolean is returned
                          } else {
                            // Existing logic: Show standard dialog if no records exist
                            return await Get.dialog<bool>(
                                  AlertDialog(
                                    title: const Text(
                                      "Confirm Deletion",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      "Are you sure you want to delete '${subject.name}'? This action cannot be undone.",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed:
                                            () => Get.back(result: false),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                      GFButton(
                                        onPressed: () => Get.back(result: true),
                                        text: "Delete",
                                        shape: GFButtonShape.pills,
                                        size: GFSize.MEDIUM,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ) ??
                                false; // Ensure a boolean is returned
                          }
                        },
                        onDismissed: (direction) {
                          if (subject.id != null) {
                            subjectController.deleteSubject(subject.id!);
                            Get.snackbar(
                              "Subject Deleted",
                              "'${subject.name}' has been removed.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.shade600,
                              colorText: Colors.white,
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => AttendanceHistoryView(subject: subject),
                            );
                          },
                          child: SubjectCard(subject: subject),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddSubjectView());
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLowAttendanceAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16, right: 16, left: 16),

      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: SColors.primary.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Low Attendance Alert\n${subjectController.lowAttendanceCount.value} subjects below 80% attendance",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceAnalyticsSection(BuildContext context) {
    final List<String> daysOfWeek = [
      'Mon',
      'Tue',
      'Wed', // Corrected: Should be 'Wed'
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final List<Color> barColors = [
      Colors.teal.shade400,
      Colors.blue.shade400,
      Colors.pink.shade400,
      Colors.orange.shade400,
      Colors.lightGreen.shade400,
      Colors.purple.shade400,
      Colors.indigo.shade400,
    ];

    final List<DailyAttendanceData> chartData = [];
    for (int i = 0; i < daysOfWeek.length; i++) {
      final day = daysOfWeek[i];
      final percentage =
          analyticsController.dailyAttendancePercentages[day] ?? 0.0;
      chartData.add(DailyAttendanceData(day, percentage));
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: SColors.primary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Attendance Analytics",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'Weekly',
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.deepPurpleAccent,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                    ],
                    onChanged: (value) {
                      // Implement logic for changing time frame if added
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: SColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SSizes.md),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 15,
                bottom: 15,
              ),
              child: SizedBox(
                height: 150,
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  plotAreaBackgroundColor: Colors.transparent,

                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLine: const AxisLine(width: 0),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                    labelPosition: ChartDataLabelPosition.outside,
                    majorTickLines: const MajorTickLines(size: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    majorGridLines: MajorGridLines(
                      width: 0.8,
                      color: Colors.grey.shade200,
                      dashArray: <double>[5, 5],
                    ),
                    axisLine: const AxisLine(width: 0),
                    minimum: 0,
                    maximum: 100,
                    interval: 25,
                    labelFormat: '{value}%',
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                    majorTickLines: const MajorTickLines(size: 0),
                  ),
                  series: <CartesianSeries<DailyAttendanceData, String>>[
                    ColumnSeries<DailyAttendanceData, String>(
                      dataSource: chartData,
                      xValueMapper: (DailyAttendanceData data, _) => data.day,
                      yValueMapper:
                          (DailyAttendanceData data, _) => data.percentage,
                      pointColorMapper: (DailyAttendanceData data, index) {
                        return barColors[index % barColors.length];
                      },
                      dataLabelSettings: DataLabelSettings(isVisible: false),
                      borderRadius: BorderRadius.circular(6),
                      width: 0.6,
                      spacing: 0.3,
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    color: Colors.deepPurpleAccent.shade700,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    format: 'point.x : {point.y}%',
                    tooltipPosition: TooltipPosition.pointer,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAnalyticsMetric(
                icon: Icons.show_chart_rounded,
                label: "Average",
                value:
                    "${analyticsController.averageAttendance.value.toStringAsFixed(0)}%",
                color: Colors.deepPurpleAccent,
              ),
              _buildAnalyticsMetric(
                icon: Icons.star_rounded,
                label: "Best Day",
                value: analyticsController.bestDay.value,
                color: Colors.green.shade600,
              ),
              _buildAnalyticsMetric(
                icon: Icons.cancel_rounded,
                label: "Missed",
                value:
                    "${analyticsController.totalMissedClassesThisWeek.value}",
                color: Colors.red.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: SColors.primary.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: color.withOpacity(0.8), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Subject subject;
  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final int attendancePercentage =
        (subject.totalClasses == 0)
            ? 0 // If totalClasses is 0, attendance is 0% (as an int)
            : ((subject.attendedClasses / subject.totalClasses) * 100).round();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: SColors.secondary.withOpacity(0.8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Subjectcircular(percentCurrent: attendancePercentage),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.book_1),
                          SizedBox(width: SSizes.sm),
                          Text(
                            subject.name,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person_2_outlined),
                          SizedBox(width: SSizes.sm),
                          Text(
                            subject.code,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.keyboard_arrow_right_outlined),
                          SizedBox(width: SSizes.sm),
                          Text(
                            "Classes: ${subject.attendedClasses}/${subject.totalClasses}",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
