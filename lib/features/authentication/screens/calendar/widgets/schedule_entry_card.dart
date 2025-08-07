import 'package:flutter/material.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/models/constants.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/models/schedule_event_model.dart';

import 'package:intl/intl.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class ScheduleEventCard extends StatelessWidget {
  final ScheduleEventModel eventModel;

  const ScheduleEventCard({super.key, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    // Format the time to display only the start hour
    final startTime = DateFormat(
      'h:mm',
    ).format(DateFormat('h:mm a').parse(eventModel.startTime));
    final endTime = DateFormat(
      'h:mm',
    ).format(DateFormat('h:mm a').parse(eventModel.endTime));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40, // Width for the time label and vertical line
          child: Text(
            startTime,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        Container(
          width: 2,
          height: 80, // Adjust height as needed
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.secondaryText.withOpacity(0.3),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: SColors.secondary.withOpacity(0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          eventModel.startTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                        Text(" - "),
                        Text(
                          eventModel.endTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    _buildSubjectTag(eventModel.tag),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  eventModel.subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.black54),
                    const SizedBox(width: 5),
                    Text(
                      eventModel.instructor,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      eventModel.room,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectTag(String tag) {
    Color tagColor;
    switch (tag.toLowerCase()) {
      case 'data science':
        tagColor = Colors.purple.shade200;
        break;
      case 'systems analysis design':
        tagColor = Colors.blue.shade200;
        break;
      case 'cybersecurity':
        tagColor = Colors.orange.shade200;
        break;
      default:
        tagColor = Colors.grey.shade200;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}
