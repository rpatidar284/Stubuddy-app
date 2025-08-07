import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_record.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

import 'manual_attendance_entry_view.dart';

class AttendanceHistoryView extends StatelessWidget {
  final Subject subject;
  final AttendanceController attendanceController =
      Get.find<AttendanceController>();

  AttendanceHistoryView({super.key, required this.subject}) {
    attendanceController.getAttendanceHistory(subject.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: Text(
          subject.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.deepPurpleAccent,
            ), // Add icon
            onPressed: () {
              Get.to(() => ManualAttendanceEntryView(subject: subject));
            },
          ),
        ],
      ),
      body: Obx(() {
        if (attendanceController.attendanceHistory.isEmpty) {
          return const Center(
            child: Text(
              "No attendance records for this subject yet.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align "Attendance History" left
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: SSizes.sm),
                  Text(
                    "Attendance History",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ), // Padding at the bottom of the list
                itemCount: attendanceController.attendanceHistory.length,
                itemBuilder: (context, index) {
                  final record = attendanceController.attendanceHistory[index];
                  return Dismissible(
                    key: Key(record.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red.shade600, // Darker red for delete
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 30,
                      ), // Larger delete icon
                    ),
                    confirmDismiss: (direction) async {
                      return await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text(
                            "Confirm Deletion",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            "Are you sure you want to delete this attendance record? This action cannot be undone.",
                            style: TextStyle(fontSize: 15),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                            GFButton(
                              onPressed: () => Get.back(result: true),
                              text: "Delete",
                              shape: GFButtonShape.pills,

                              size: GFSize.LARGE,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      if (record.id != null) {
                        attendanceController.deleteAttendanceRecord(
                          record.id!,
                          record.subjectId,
                          record.isPresent,
                        );
                        Get.snackbar(
                          "Record Deleted",
                          "Attendance record for ${DateFormat('dd/MM/yyyy').format(record.date)} deleted.",
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
                    child: AttendanceRecordCard(record: record),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class AttendanceRecordCard extends StatelessWidget {
  final AttendanceRecord record;
  const AttendanceRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ), // Slightly more vertical margin
      elevation: 2, // Subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Rounded corners
      color: Colors.white, // White card background
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ), // Padding inside card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                record.isPresent
                    ? Icon(Iconsax.tick_circle, color: Colors.green)
                    : Icon(Iconsax.tick_circle, color: Colors.red),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(record.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.topic.isEmpty ? "No topic" : record.topic,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            Chip(
              label: Text(
                record.isPresent ? "Present" : "Absent",

                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              backgroundColor:
                  record.isPresent
                      ? Colors.green.shade500.withOpacity(0.3)
                      : Colors.red.shade500.withOpacity(0.3), // Chip background
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
