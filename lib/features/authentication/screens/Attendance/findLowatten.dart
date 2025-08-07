import 'package:flutter/material.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/customcard.dart';
import 'package:stu_buddy/features/authentication/screens/home/Widget/Lowattens.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

import 'package:stu_buddy/utils/local_storage/SQLite.dart'; // Import your DBHelper

class SingleLowestAttendanceSubjectCard extends StatefulWidget {
  const SingleLowestAttendanceSubjectCard({super.key});

  @override
  State<SingleLowestAttendanceSubjectCard> createState() =>
      _SingleLowestAttendanceSubjectCardState();
}

class _SingleLowestAttendanceSubjectCardState
    extends State<SingleLowestAttendanceSubjectCard> {
  Map<String, dynamic>? _lowestSubject;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLowestAttendanceSubject();
  }

  Future<void> _fetchLowestAttendanceSubject() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _lowestSubject = await DBHelper.getInstance.getLowestAttendanceSubject();
    } catch (e) {
      print('Error fetching lowest attendance subject: $e');
      // Handle error (e.g., show a message to the user)
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _lowestSubject ==
            null // <--- THIS IS THE KEY CHECK
        ? customcard(
          height: 250,
          width: 200,
          elevation: 0,
          color: SColors.primary.withOpacity(0.1),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(SSizes.defaultSpace),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          'assets/images/FreCard/lowatten.jpg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                      SizedBox(width: SSizes.sm),
                      Text(
                        'Low atten.',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 75),
                  Text('No subjects added yet!'),
                ],
              ),
            ),
          ),
        )
        : Attencard(
          // <--- THIS IS WHERE THE ERROR LIKELY OCCURS IF _lowestSubject IS NULL
          subjectName: _lowestSubject![DBHelper.COL_SUB_NAME],
          subjectCode: _lowestSubject![DBHelper.COL_SUB_CODE],
          attendancePercentage: _lowestSubject!['attendancePercentage'],
          // instructorName: 'Instructor Name (if available from other data)',
        );
  }
}
