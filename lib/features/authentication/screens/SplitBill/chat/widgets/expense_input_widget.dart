import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/widgets/custom_icon_widget.dart';

/// Widget for inputting new expenses
/// Contains amount field, description, category selector, and send button
class ExpenseInputWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onExpenseAdded;

  const ExpenseInputWidget({super.key, required this.onExpenseAdded});

  @override
  State<ExpenseInputWidget> createState() => _ExpenseInputWidgetState();
}

class _ExpenseInputWidgetState extends State<ExpenseInputWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'food';

  final List<Map<String, String>> _categories = [
    {'name': 'food', 'icon': 'restaurant', 'label': 'Food'},
    {'name': 'transport', 'icon': 'directions_car', 'label': 'Transport'},
    {'name': 'rent', 'icon': 'home', 'label': 'Rent'},
    {'name': 'entertainment', 'icon': 'movie', 'label': 'Entertainment'},
    {'name': 'shopping', 'icon': 'shopping_bag', 'label': 'Shopping'},
    {'name': 'bills', 'icon': 'receipt_long', 'label': 'Bills'},
    {'name': 'other', 'icon': 'attach_money', 'label': 'Other'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category selector
            Container(
              height: 8.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['name']!;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 2.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? colorScheme.primary.withValues(alpha: 0.1)
                                : colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: category['icon']!,
                            color:
                                isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            category['label']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
            // Input fields
            Row(
              children: [
                // Amount field
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: '₹ Amount',
                      prefixIcon: CustomIconWidget(
                        iconName: 'currency_rupee',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                SizedBox(width: 2.w),
                // Description field
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 2.w),
                // Send button
                GestureDetector(
                  onTap: _sendExpense,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color:
                          _canSendExpense()
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'send',
                      color:
                          _canSendExpense()
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _canSendExpense() {
    return _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0;
  }

  void _sendExpense() {
    if (!_canSendExpense()) return;

    final expense = {
      'amount': double.parse(_amountController.text),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    widget.onExpenseAdded(expense);

    // Clear inputs
    _amountController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = 'food';
    });
  }
}
