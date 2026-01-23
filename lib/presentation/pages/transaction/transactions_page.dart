import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../app.dart';
import '../../../core/constants/icons.dart' as icon_constants;
import '../../../core/router/app_router.dart';
import '../../../di/injection.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../../cubit/home/home_cubit.dart';
import '../../cubit/transaction/view_transactions_cubit.dart';
import '../../widgets/common/empty_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/transaction/transaction_item.dart';

@RoutePage()
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {

  DateTime? _startDate;
  DateTime? _endDate;
  TransactionType? _selectedType;
  int? _selectedCategoryId;

  void _refreshHomeSummary() {
    try {
      final homeCubit = getIt<HomeCubit>();
      final now = DateTime.now();
      homeCubit.getMonthlySummary(now.year, now.month);
    } catch (e) {
      // Cubit might not be initialized yet, ignore
    }
  }

  Future<void> _selectDateRange(BuildContext context, ViewTransactionsCubit cubit) async {
    DateTime? tempStartDate = _startDate;
    DateTime? tempEndDate = _endDate;
    TransactionType? tempType = _selectedType;
    int? tempCategoryId = _selectedCategoryId;
    List<Category>? categories;
    bool isLoadingCategories = true;

    // Load categories
    final getCategoriesUseCase = getIt<GetCategoriesUseCase>();
    final categoriesResult = await getCategoriesUseCase();
    categoriesResult.fold(
      (failure) => categories = [],
      (loadedCategories) => categories = loadedCategories,
    );
    isLoadingCategories = false;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.filter),
        content: SizedBox(
          width: double.maxFinite,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Transaction Type Filter
                    Text(
                      context.l10n.transactionType,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 12.h),
                    SegmentedButton<TransactionType?>(
                      segments: [
                        ButtonSegment<TransactionType?>(
                          value: null,
                          label: Text(context.l10n.all),
                        ),
                        ButtonSegment<TransactionType?>(
                          value: TransactionType.expense,
                          label: Text(context.l10n.expense),
                          icon: const Icon(Icons.arrow_downward),
                        ),
                        ButtonSegment<TransactionType?>(
                          value: TransactionType.income,
                          label: Text(context.l10n.income),
                          icon: const Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: {tempType},
                      onSelectionChanged: (Set<TransactionType?> newSelection) {
                        setDialogState(() {
                          tempType = newSelection.first;
                        });
                      },
                    ),
                    SizedBox(height: 24.h),
                    // Category Filter
                    Text(
                      context.l10n.category,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 12.h),
                    if (isLoadingCategories)
                      const SizedBox(
                        height: 50,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      DropdownButtonFormField<int?>(
                        value: tempCategoryId,
                        decoration: InputDecoration(
                          labelText: context.l10n.selectCategory,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(context.l10n.all),
                          ),
                          ...(categories ?? []).map((category) {
                            return DropdownMenuItem<int?>(
                              value: category.id,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (category.icon != null && category.color != null)
                                    Icon(
                                      _getIconFromString(category.icon!),
                                      color: _parseColor(category.color!),
                                      size: 16.sp,
                                    ),
                                  if (category.icon != null && category.color != null)
                                    SizedBox(width: 8.w),
                                  Flexible(
                                    child: Text(
                                      category.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            tempCategoryId = value;
                          });
                        },
                      ),
                    SizedBox(height: 24.h),
                    // Start Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.l10n.startDate),
                      subtitle: Text(
                        tempStartDate != null
                            ? DateFormat('yyyy-MM-dd').format(tempStartDate!)
                            : context.l10n.notSelected,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: tempStartDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: tempEndDate ?? DateTime(2100),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              tempStartDate = picked;
                              if (tempEndDate != null && tempEndDate!.isBefore(tempStartDate!)) {
                                tempEndDate = null;
                              }
                            });
                          }
                        },
                      ),
                    ),
                    // End Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.l10n.endDate),
                      subtitle: Text(
                        tempEndDate != null
                            ? DateFormat('yyyy-MM-dd').format(tempEndDate!)
                            : context.l10n.notSelected,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final initialDate = tempEndDate ?? tempStartDate ?? DateTime.now();
                          final firstDate = tempStartDate ?? DateTime(2000);
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: firstDate,
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              tempEndDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    if (tempStartDate != null || tempEndDate != null || tempType != null || tempCategoryId != null)
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: TextButton(
                          onPressed: () {
                            setDialogState(() {
                              tempStartDate = null;
                              tempEndDate = null;
                              tempType = null;
                              tempCategoryId = null;
                            });
                          },
                          child: Text(context.l10n.clear),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop({
                'startDate': tempStartDate,
                'endDate': tempEndDate,
                'type': tempType,
                'categoryId': tempCategoryId,
              });
            },
            child: Text(context.l10n.apply),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _startDate = result['startDate'] as DateTime?;
        _endDate = result['endDate'] as DateTime?;
        _selectedType = result['type'] as TransactionType?;
        _selectedCategoryId = result['categoryId'] as int?;
      });
      cubit.getTransactions(
        startDate: _startDate,
        endDate: _endDate,
        type: _selectedType,
        categoryId: _selectedCategoryId,
      );
    }
  }

  IconData _getIconFromString(String iconName) {
    // Import icons list
    final iconList = icon_constants.icons;
    final icon = iconList.firstWhere(
      (appIcon) => appIcon.title == iconName,
      orElse: () => iconList.first,
    );
    return icon.iconData;
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ViewTransactionsCubit>()..getTransactions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.transactions),
          centerTitle: true,
          actions: [
            BlocBuilder<ViewTransactionsCubit, ViewTransactionsState>(
              builder: (context, state) {
                return IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.filter_alt),
                      if (_startDate != null || _endDate != null || _selectedType != null || _selectedCategoryId != null)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  tooltip: context.l10n.filter,
                  onPressed: () => _selectDateRange(
                    context,
                    context.read<ViewTransactionsCubit>(),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () async {
              final result = await context.router.push(AddTransactionRoute());
              // Refresh transactions after returning from create
              if (context.mounted) {
                final cubit = context.read<ViewTransactionsCubit>();
                cubit.getTransactions(
                  startDate: _startDate,
                  endDate: _endDate,
                  type: _selectedType,
                );
                // If transaction was created/updated, refresh home summary
                if (result == true) {
                  _refreshHomeSummary();
                }
              }
            },
            tooltip: context.l10n.addTransaction,
            child: const Icon(Icons.add),
          ),
        ),
        body: BlocConsumer<ViewTransactionsCubit, ViewTransactionsState>(
          listener: (context, state) {
            if (state is ViewTransactionsDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.transactionDeletedSuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ViewTransactionsDeleteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ViewTransactionsLoading) {
              return const LoadingWidget();
            }

            if (state is ViewTransactionsError) {
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
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        final cubit = context.read<ViewTransactionsCubit>();
                        cubit.getTransactions(
                          startDate: _startDate,
                          endDate: _endDate,
                          type: _selectedType,
                          categoryId: _selectedCategoryId,
                        );
                      },
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              );
            }

            List<Transaction> transactions = [];
            if (state is ViewTransactionsSuccess) {
              transactions = state.transactions;
            } else if (state is ViewTransactionsDeleting) {
              transactions = state.transactions;
            } else if (state is ViewTransactionsDeleteSuccess) {
              transactions = state.transactions;
            } else if (state is ViewTransactionsDeleteError) {
              transactions = state.transactions;
            }

            if (transactions.isEmpty && state is! ViewTransactionsInitial) {
              return EmptyWidget(
                message: context.l10n.noTransactionsFound,
                icon: Icons.receipt_long_outlined,
              );
            }

            if (transactions.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  final cubit = context.read<ViewTransactionsCubit>();
                  cubit.getTransactions(
                    startDate: _startDate,
                    endDate: _endDate,
                    type: _selectedType,
                    categoryId: _selectedCategoryId,
                  );
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      onTap: () async {
                        final result = await context.router.push(
                            AddTransactionRoute(transaction: transaction));
                        // Refresh transactions after returning from edit
                        if (context.mounted) {
                          final cubit = context.read<ViewTransactionsCubit>();
                          cubit.getTransactions(
                            startDate: _startDate,
                            endDate: _endDate,
                            type: _selectedType,
                            categoryId: _selectedCategoryId,
                          );
                          // If transaction was updated, refresh home summary
                          if (result == true) {
                            _refreshHomeSummary();
                          }
                        }
                      },
                      onDelete: () {
                        context.read<ViewTransactionsCubit>().deleteTransaction(transaction.id);
                        // Refresh home summary after delete
                        _refreshHomeSummary();
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
