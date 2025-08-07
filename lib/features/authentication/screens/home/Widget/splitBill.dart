import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/customcard.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/services/firebase_service.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/stats_bar.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

class SplitbillTracker extends StatefulWidget {
  const SplitbillTracker({super.key});

  @override
  State<SplitbillTracker> createState() => _SplitbillTrackerState();
}

class _SplitbillTrackerState extends State<SplitbillTracker> {
  bool _isLoading = true;

  double _totalPaid = 0.0;
  double _totalOwed = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchSummaryData();
  }

  Future<void> _fetchSummaryData() async {
    final firebaseService = FirebaseService.getInstance;
    final currentUser = firebaseService.getCurrentUser();
    if (currentUser == null) return;

    final allExpenses = await firebaseService.getAllUserExpenses();

    double paid = 0.0;
    double owed = 0.0;

    for (final expenseDoc in allExpenses) {
      final data = expenseDoc.data() as Map<String, dynamic>;
      if (data['type'] == 'expense' &&
          data['amount'] != null &&
          data['paidBy'] != null) {
        final amount = (data['amount'] as num).toDouble();

        // This logic assumes an equal split.
        if (data['paidBy'] == currentUser.uid) {
          paid += amount;
        } else {
          owed += amount;
        }
      }
    }

    setState(() {
      _totalPaid = paid;
      _totalOwed = owed;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    double earnedValue = _totalPaid;
    double outlayValue = _totalOwed;
    double savingsValue = earnedValue - outlayValue;

    double maxForProgress = (earnedValue > outlayValue
            ? earnedValue
            : outlayValue)
        .clamp(1, double.infinity);

    final double earnedProgress = earnedValue / maxForProgress;
    final double outlayProgress = outlayValue / maxForProgress;
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return customcard(
      height: 250,
      width: 220,
      elevation: 0,
      color: SColors.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/FreCard/bill.avif',
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(width: SSizes.sm),
                const Text(
                  'Split Tracker',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currencyFormat.format(savingsValue),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // --- Paid Bar (You paid) ---
            StatsBar(
              label: 'Owed',
              value: currencyFormat.format(earnedValue),
              progress: earnedProgress,
              barColor: Colors.green,
            ),
            const SizedBox(height: 16),

            // --- Owed Bar (Others paid) ---
            StatsBar(
              label: 'Paid',
              value: currencyFormat.format(outlayValue),
              progress: outlayProgress,
              barColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
