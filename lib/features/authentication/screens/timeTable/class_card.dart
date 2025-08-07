// File: lib/widgets/class_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/customcard.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

class ClassCard extends StatelessWidget {
  final String time;
  final String subject;
  final String room;
  final String instructor;

  const ClassCard({
    super.key,
    required this.time,
    required this.subject,
    required this.room,
    required this.instructor,
  });

  @override
  Widget build(BuildContext context) {
    return customcard(
      elevation: 0,
      height: 140,
      color: SColors.primary.withOpacity(0.1),

      child: Padding(
        padding: const EdgeInsets.all(SSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Iconsax.book_1),
                    SizedBox(width: SSizes.sm),
                    Text(
                      subject,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SSizes.sm),

                Row(
                  children: [
                    Icon(Iconsax.timer),
                    SizedBox(width: SSizes.sm),

                    Text(time, style: TextStyle(color: Colors.black)),
                  ],
                ),
                const SizedBox(height: SSizes.sm),
                Row(
                  children: [
                    Icon(Iconsax.location),
                    SizedBox(width: SSizes.sm),
                    card(room: room, color: SColors.accent.withOpacity(0.2)),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                card(
                  room: 'Present',
                  color: Colors.lightGreenAccent.withOpacity(0.4),
                ),
                card(room: "Absent", color: SColors.error.withOpacity(0.2)),
                SizedBox(height: SSizes.sm),
                Row(
                  children: [
                    Icon(Icons.person_2_outlined),
                    SizedBox(width: SSizes.sm),

                    Text(instructor, style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class card extends StatelessWidget {
  card({super.key, required this.room, this.color = SColors.white});

  final String room;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Text(room, style: TextStyle(fontSize: 12, color: Colors.black)),
      ),
    );
  }
}
