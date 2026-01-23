import 'package:equatable/equatable.dart';
import 'base_entity.dart';
import 'expense_by_category.dart';

class Summary extends BaseEntity {
  final int year;
  final int month;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<ExpenseByCategory> expenseByCategory;

  const Summary({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.expenseByCategory,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        totalIncome,
        totalExpense,
        balance,
        expenseByCategory,
      ];
}
