import 'base_entity.dart';

class ExpenseByCategory extends BaseEntity {
  final int categoryId;
  final String categoryName;
  final double totalAmount;
  final int percentage;
  final String? icon;
  final String? color;

  const ExpenseByCategory({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
    this.icon,
    this.color,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, totalAmount, percentage, icon, color];
}
