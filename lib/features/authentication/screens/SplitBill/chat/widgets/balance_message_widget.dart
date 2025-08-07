import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';

/// Widget displaying balance information as a system message
/// Shows running balance between expense groups
class BalanceMessageWidget extends StatelessWidget {
  final double balance;
  final String contactName;

  const BalanceMessageWidget({
    super.key,
    required this.balance,
    required this.contactName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            _getBalanceText(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _getBalanceColor(colorScheme),
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _getBalanceText() {
    if (balance == 0) {
      return 'All settled up! 🎉';
    } else if (balance > 0) {
      return '$contactName owes you ₹${balance.abs().toStringAsFixed(2)}';
    } else {
      return 'You owe $contactName ₹${balance.abs().toStringAsFixed(2)}';
    }
  }

  Color _getBalanceColor(ColorScheme colorScheme) {
    if (balance == 0) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else if (balance > 0) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
