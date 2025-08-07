import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_record.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class ManualAttendanceEntryView extends StatefulWidget {
  final Subject? subject;

  const ManualAttendanceEntryView({super.key, this.subject});

  @override
  _ManualAttendanceEntryViewState createState() =>
      _ManualAttendanceEntryViewState();
}

class _ManualAttendanceEntryViewState extends State<ManualAttendanceEntryView> {
  final SubjectController subjectController = Get.find();
  final AttendanceController attendanceController = Get.find();

  Subject? _selectedSubject;
  DateTime _selectedDate = DateTime.now();
  bool _isPresent = true;
  final _topicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSubject = widget.subject;
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text(
          "Manual Attendance Entry",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.deepOrangeAccent[400],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Subject",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ), // Adjusted padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // Consistent rounding
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Obx(() {
                List<Subject> currentSubjects =
                    subjectController.subjects.toList();

                if (currentSubjects.isEmpty) {
                  _selectedSubject = null;
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<Subject>(
                      hint: const Text('No subjects available'),
                      value: null,
                      items: const [],
                      onChanged: null,
                    ),
                  );
                }

                if (_selectedSubject == null && currentSubjects.isNotEmpty) {
                  _selectedSubject = currentSubjects.first;
                }

                Subject? matchedSubjectInList;
                if (_selectedSubject != null) {
                  matchedSubjectInList = currentSubjects.firstWhereOrNull(
                    (s) => s.id == _selectedSubject!.id,
                  );
                }

                if (matchedSubjectInList != null) {
                  _selectedSubject = matchedSubjectInList;
                } else {
                  _selectedSubject = currentSubjects.first;
                }

                return DropdownButtonHideUnderline(
                  child: DropdownButton<Subject>(
                    isExpanded: true,
                    hint: const Text('Choose a subject'),
                    value: _selectedSubject,
                    items:
                        currentSubjects.map((s) {
                          return DropdownMenuItem<Subject>(
                            value: s,
                            child: Text(
                              s.name,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                    onChanged:
                        currentSubjects.isEmpty
                            ? null
                            : (Subject? newValue) {
                              setState(() {
                                _selectedSubject = newValue;
                              });
                            },
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Date",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.deepPurpleAccent,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.deepPurpleAccent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.deepPurpleAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Attendance Status",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isPresent = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _isPresent ? Colors.green.shade50 : Colors.white,
                        border: Border.all(
                          color:
                              _isPresent
                                  ? Colors.green.shade500
                                  : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                _isPresent
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color:
                                _isPresent
                                    ? Colors.green.shade600
                                    : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Present",
                            style: TextStyle(
                              color:
                                  _isPresent
                                      ? Colors.green.shade800
                                      : Colors.black87,
                              fontWeight:
                                  _isPresent
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isPresent = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: !_isPresent ? Colors.red.shade50 : Colors.white,
                        border: Border.all(
                          color:
                              !_isPresent
                                  ? Colors.red.shade500
                                  : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                !_isPresent
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color:
                                !_isPresent
                                    ? Colors.red.shade600
                                    : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Absent",
                            style: TextStyle(
                              color:
                                  !_isPresent
                                      ? Colors.red.shade800
                                      : Colors.black87,
                              fontWeight:
                                  !_isPresent
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Topic (Optional)",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                hintText: "Enter class topic or notes",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GFButton(
                    onPressed: () => Get.back(),
                    text: "Cancel",
                    shape: GFButtonShape.pills,
                    type: GFButtonType.outline2x,
                    size: GFSize.LARGE,
                    color: SColors.buttonPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GFButton(
                    onPressed: () {
                      if (_selectedSubject == null) {
                        Get.snackbar(
                          "Error",
                          "Please select a subject.",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      final newRecord = AttendanceRecord(
                        subjectId: _selectedSubject!.id!,
                        date: _selectedDate,
                        isPresent: _isPresent,
                        topic: _topicController.text,
                      );

                      attendanceController.addAttendanceRecord(newRecord);
                      subjectController.updateSubjectAttendance(
                        _selectedSubject!.id!,
                        _isPresent,
                      );

                      setState(() {
                        _selectedSubject = null;
                        _topicController.clear();
                        _selectedDate = DateTime.now();
                        _isPresent = true;
                      });

                      Get.back();
                    },
                    text: "Save",
                    shape: GFButtonShape.pills,
                    size: GFSize.LARGE,
                    color: SColors.buttonPrimary,
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
