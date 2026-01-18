import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app.dart';
import '../../../core/router/app_router.dart';
import '../../../di/injection.dart';
import '../../../domain/entities/transaction.dart';
import '../../cubit/transaction/view_transactions_cubit.dart';
import '../../widgets/common/empty_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/transaction/transaction_item.dart';

@RoutePage()
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ViewTransactionsCubit>()..getTransactions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.transactions),
          centerTitle: true,
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () async {
              await context.router.push(AddTransactionRoute());
              // Refresh transactions after returning from create
              if (context.mounted) {
                context.read<ViewTransactionsCubit>().getTransactions();
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
                        context.read<ViewTransactionsCubit>().getTransactions();
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
                  context.read<ViewTransactionsCubit>().getTransactions();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      onTap: () async {
                        await context.router.push(
                            AddTransactionRoute(transaction: transaction));
                        // Refresh transactions after returning from edit
                        if (context.mounted) {
                          context.read<ViewTransactionsCubit>().getTransactions();
                        }
                      },
                      onDelete: () {
                        context.read<ViewTransactionsCubit>().deleteTransaction(transaction.id);
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
