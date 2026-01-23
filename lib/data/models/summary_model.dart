import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/summary.dart';
import 'expense_by_category_model.dart';

part 'summary_model.freezed.dart';
part 'summary_model.g.dart';

@freezed
class SummaryModel with _$SummaryModel {
  const SummaryModel._();

  const factory SummaryModel({
    required int year,
    required int month,
    required double totalIncome,
    required double totalExpense,
    required double balance,
    required List<ExpenseByCategoryModel> expenseByCategory,
  }) = _SummaryModel;

  factory SummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SummaryModelFromJson(json);

  Summary toEntity() {
    return Summary(
      year: year,
      month: month,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: balance,
      expenseByCategory: expenseByCategory.map((e) => e.toEntity()).toList(),
    );
  }
}
