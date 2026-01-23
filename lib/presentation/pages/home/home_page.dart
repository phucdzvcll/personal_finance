import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../app.dart';
import '../../../core/constants/icons.dart';
import '../../../domain/entities/expense_by_category.dart';
import '../../../di/injection.dart';
import '../../cubit/home/home_cubit.dart';
import '../../widgets/common/loading_widget.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum ExpenseViewMode { list, pieChart }

class _HomePageState extends State<HomePage> {
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  ExpenseViewMode _expenseViewMode = ExpenseViewMode.list;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectMonthYear(BuildContext context, HomeCubit cubit) async {
    int tempYear = _selectedYear;
    int tempMonth = _selectedMonth;

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.selectMonthYear),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Year selector
                  Text(
                    context.l10n.year,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            tempYear--;
                          });
                        },
                      ),
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          tempYear.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            tempYear++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // Month selector
                  Text(
                    context.l10n.month,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final isSelected = month == tempMonth;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            tempMonth = month;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('MMM').format(DateTime(2024, month)),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop({
                'year': tempYear,
                'month': tempMonth,
              });
            },
            child: Text(context.l10n.select),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _selectedYear = result['year']!;
        _selectedMonth = result['month']!;
      });
      // Load summary for selected month/year
      cubit.getMonthlySummary(_selectedYear, _selectedMonth);
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _getMonthName(int year, int month) {
    return DateFormat('MMMM yyyy').format(DateTime(year, month));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<HomeCubit>();
        // Load summary for current month after provider is created
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final now = DateTime.now();
          _selectedYear = now.year;
          _selectedMonth = now.month;
          cubit.getMonthlySummary(now.year, now.month);
        });
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.appName),
          centerTitle: true,
          actions: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.filter_alt),
                  tooltip: context.l10n.filter,
                  onPressed: () => _selectMonthYear(context, context.read<HomeCubit>()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: LoadingWidget());
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().getMonthlySummary(_selectedYear, _selectedMonth);
                      },
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeSuccess) {
              final summary = state.summary;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeCubit>().getMonthlySummary(summary.year, summary.month);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with filter button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${context.l10n.monthlySummary} - ${_getMonthName(summary.year, summary.month)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            tooltip: context.l10n.selectMonthYear,
                            onPressed: () => _selectMonthYear(context, context.read<HomeCubit>()),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Summary Cards
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: context.l10n.totalIncome,
                              amount: summary.totalIncome,
                              color: Colors.green,
                              icon: Icons.arrow_upward,
                              formatCurrency: _formatCurrency,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _SummaryCard(
                              title: context.l10n.totalExpense,
                              amount: summary.totalExpense,
                              color: Colors.red,
                              icon: Icons.arrow_downward,
                              formatCurrency: _formatCurrency,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SummaryCard(
                        title: context.l10n.balance,
                        amount: summary.balance,
                        color: summary.balance >= 0 ? Colors.blue : Colors.orange,
                        icon: Icons.account_balance_wallet,
                        formatCurrency: _formatCurrency,
                      ),
                      SizedBox(height: 32.h),
                      // Expense by Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              context.l10n.expenseByCategory,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SegmentedButton<ExpenseViewMode>(
                            segments: [
                              ButtonSegment<ExpenseViewMode>(
                                value: ExpenseViewMode.list,
                                icon: const Icon(Icons.list, size: 18),
                                label: Text(context.l10n.list, style: TextStyle(fontSize: 12.sp)),
                              ),
                              ButtonSegment<ExpenseViewMode>(
                                value: ExpenseViewMode.pieChart,
                                icon: const Icon(Icons.pie_chart, size: 18),
                                label: Text(context.l10n.chart, style: TextStyle(fontSize: 12.sp)),
                              ),
                            ],
                            selected: {_expenseViewMode},
                            onSelectionChanged: (Set<ExpenseViewMode> newSelection) {
                              setState(() {
                                _expenseViewMode = newSelection.first;
                              });
                            },
                            style: SegmentedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (summary.expenseByCategory.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.h),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.pie_chart_outline,
                                  size: 48.sp,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  context.l10n.noExpenseData,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_expenseViewMode == ExpenseViewMode.list)
                        ...summary.expenseByCategory.map((expense) {
                          return _ExpenseCategoryItem(
                            expense: expense,
                            formatCurrency: _formatCurrency,
                          );
                        })
                      else
                        _ExpensePieChart(
                          expenses: summary.expenseByCategory,
                          formatCurrency: _formatCurrency,
                        ),
                    ],
                  ),
                ),
              );
            }

            // Initial state
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 64.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.welcomeToPersonalFinance,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.startManagingFinances,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final String Function(double) formatCurrency;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              formatCurrency(amount),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCategoryItem extends StatelessWidget {
  final ExpenseByCategory expense;
  final String Function(double) formatCurrency;

  const _ExpenseCategoryItem({
    required this.expense,
    required this.formatCurrency,
  });

  Color _parseColor(String? colorHex, BuildContext context) {
    if (colorHex == null || colorHex.isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }
    try {
      // Remove # if present
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }

  IconData? _getIconData(String? iconName) {
    if (iconName == null || iconName.isEmpty) return null;
    try {
      final icon = icons.firstWhere(
        (icon) => icon.title == iconName,
        orElse: () => icons.first,
      );
      return icon.iconData;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _parseColor(expense.color, context);
    final iconData = _getIconData(expense.icon);

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (iconData != null) ...[
                        FaIcon(
                          iconData,
                          color: categoryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Expanded(
                        child: Text(
                          expense.categoryName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${expense.percentage}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              formatCurrency(expense.totalAmount),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: expense.percentage / 100,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensePieChart extends StatelessWidget {
  final List<ExpenseByCategory> expenses;
  final String Function(double) formatCurrency;

  const _ExpensePieChart({
    required this.expenses,
    required this.formatCurrency,
  });

  Color _parseColor(String? colorHex, BuildContext context) {
    if (colorHex == null || colorHex.isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }
    try {
      // Remove # if present
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }

  IconData? _getIconData(String? iconName) {
    if (iconName == null || iconName.isEmpty) return null;
    try {
      final icon = icons.firstWhere(
        (icon) => icon.title == iconName,
        orElse: () => icons.first,
      );
      return icon.iconData;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(
              height: 300.h,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60.r,
                  sections: expenses.map((expense) {
                    final categoryColor = _parseColor(expense.color, context);
                    return PieChartSectionData(
                      value: expense.totalAmount,
                      title: '${expense.percentage}%',
                      color: categoryColor,
                      radius: 80.r,
                      titleStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Legend
            Wrap(
              spacing: 16.w,
              runSpacing: 8.h,
              children: expenses.map((expense) {
                final categoryColor = _parseColor(expense.color, context);
                final iconData = _getIconData(expense.icon);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (iconData != null) ...[
                      FaIcon(
                        iconData,
                        color: categoryColor,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                    ],
                    Text(
                      expense.categoryName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '(${formatCurrency(expense.totalAmount)})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
