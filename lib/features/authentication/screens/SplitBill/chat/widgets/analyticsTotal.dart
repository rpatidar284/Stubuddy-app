import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/services/firebase_service.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/widgets/custom_icon_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsDashboardT extends StatefulWidget {
  const AnalyticsDashboardT({super.key});

  @override
  State<AnalyticsDashboardT> createState() => _AnalyticsDashboardTState();
}

class _AnalyticsDashboardTState extends State<AnalyticsDashboardT> {
  bool _isLoading = true;
  List<ChartData> _chartData = [];
  double _totalAmount = 0;
  String _topCategory = 'N/A';
  int _totalCategories = 0;

  @override
  void initState() {
    super.initState();
    _fetchAnalyticsData();
  }

  Future<void> _fetchAnalyticsData() async {
    setState(() {
      _isLoading = true;
    });

    final firebaseService = FirebaseService.getInstance;
    final allExpenses = await firebaseService.getAllUserExpenses();

    final Map<String, double> categoryTotals = {};
    for (final expenseDoc in allExpenses) {
      final data = expenseDoc.data() as Map<String, dynamic>;
      if (data['type'] == 'expense' &&
          data['category'] != null &&
          data['amount'] != null) {
        final category = data['category'] as String;
        final amount = (data['amount'] as num).toDouble();
        categoryTotals[category] = (categoryTotals[category] ?? 0.0) + amount;
      }
    }

    _totalAmount = categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );
    _totalCategories = categoryTotals.keys.length;
    _chartData =
        categoryTotals.entries.map((entry) {
          final percentage =
              (_totalAmount > 0) ? (entry.value / _totalAmount) * 100 : 0;
          return ChartData(
            x: entry.key,
            y: entry.value,
            color: _getCategoryColor(entry.key),
            percentage: percentage.toStringAsFixed(1),
          );
        }).toList();

    _chartData.sort((a, b) => b.y.compareTo(a.y));
    if (_chartData.isNotEmpty) {
      _topCategory = _chartData.first.x;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.blue;
      case 'transport':
        return Colors.green;
      case 'entertainment':
        return Colors.orange;
      case 'shopping':
        return Colors.deepPurple;
      case 'bills':
        return Colors.red;
      case 'healthcare':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _buildCategoryBreakdownCard(context);
  }

  Widget _buildCategoryBreakdownCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 20.h,
                    child: SfCircularChart(
                      series: <DoughnutSeries<ChartData, String>>[
                        DoughnutSeries<ChartData, String>(
                          dataSource: _chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          pointColorMapper: (ChartData data, _) => data.color,
                          dataLabelMapper:
                              (ChartData data, _) =>
                                  data.y > 0
                                      ? '₹${data.y.toStringAsFixed(0)}'
                                      : '',
                          startAngle: 90,
                          endAngle: 90,
                          radius: '80%',
                          innerRadius: '60%',
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: theme.textTheme.bodySmall,
                            labelPosition: ChartDataLabelPosition.outside,
                            connectorLineSettings: const ConnectorLineSettings(
                              type: ConnectorType.curve,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _chartData.map((data) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 1.5.w,
                                    height: 1.5.w,
                                    decoration: BoxDecoration(
                                      color: data.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      '${data.x}\n₹${data.y.toStringAsFixed(0)} (${data.percentage}%)',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(fontSize: 10.sp),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              const Divider(),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Categories',
                        style: theme.textTheme.labelMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _totalCategories.toString(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total Amount', style: theme.textTheme.labelMedium),
                      SizedBox(height: 1.h),
                      Text(
                        '₹${_totalAmount.toStringAsFixed(0)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Top Category', style: theme.textTheme.labelMedium),
                      SizedBox(height: 1.h),
                      Text(
                        _topCategory,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData({
    required this.x,
    required this.y,
    required this.color,
    required this.percentage,
  });
  final String x;
  final num y;
  final Color color;
  final String percentage;
}
