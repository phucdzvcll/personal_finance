import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/expense_by_category.dart';

part 'expense_by_category_model.freezed.dart';
part 'expense_by_category_model.g.dart';

@freezed
class ExpenseByCategoryModel with _$ExpenseByCategoryModel {
  const ExpenseByCategoryModel._();

  const factory ExpenseByCategoryModel({
    required int categoryId,
    required String categoryName,
    required double totalAmount,
    required int percentage,
    String? icon,
    String? color,
  }) = _ExpenseByCategoryModel;

  factory ExpenseByCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseByCategoryModelFromJson(json);

  ExpenseByCategory toEntity() {
    return ExpenseByCategory(
      categoryId: categoryId,
      categoryName: categoryName,
      totalAmount: totalAmount,
      percentage: percentage,
      icon: icon,
      color: color,
    );
  }
}
