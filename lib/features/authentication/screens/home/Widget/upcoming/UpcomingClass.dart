import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/customcard.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class UpcomingClass extends StatefulWidget {
  const UpcomingClass({super.key});

  @override
  State<UpcomingClass> createState() => _UpcomingClassState();
}

class _UpcomingClassState extends State<UpcomingClass> {
  List<Map<String, dynamic>> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodayClasses();
  }

  Future<void> fetchTodayClasses() async {
    final String today =
        DateFormat('EEE').format(DateTime.now()).toUpperCase(); // e.g., THU
    final data = await DBHelper.getInstance.getClassesByDay(today);

    setState(() {
      _classes = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: customcard(
        elevation: 0,
        color: SColors.primary.withOpacity(0.1),
        height: 225,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: SSizes.lg,
                top: SSizes.lg,
                bottom: SSizes.sm,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      'assets/images/FreCard/up.avif',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const SizedBox(width: SSizes.sm),
                  const Text(
                    "Upcoming Classes",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _classes.isEmpty
                ? SizedBox(
                  height: 130,
                  child: Center(
                    child: Text(
                      "No class today.",
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                  ),
                )
                : SizedBox(
                  height: 130,
                  child: PageView.builder(
                    itemCount: _classes.length,
                    controller: PageController(viewportFraction: 0.85),
                    itemBuilder: (context, index) {
                      final item = _classes[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: customcard(
                          elevation: 1,
                          height: 130,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('dd').format(DateTime.now()),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'EEE',
                                        ).format(DateTime.now()).toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: SColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(Iconsax.book_1),
                                          const SizedBox(width: SSizes.sm),
                                          Text(
                                            item['subject'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Iconsax.timer),
                                          const SizedBox(width: SSizes.sm),
                                          Text(item['time']),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.person_outline),
                                          const SizedBox(width: SSizes.sm),
                                          Text(
                                            item['instructor'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
