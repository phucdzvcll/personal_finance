import 'base_entity.dart';
import 'transaction_type.dart';

class Transaction extends BaseEntity {
  final int id;
  final double amount;
  final TransactionType type;
  final int categoryId;
  final String transactionDate;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.transactionDate,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        type,
        categoryId,
        transactionDate,
        note,
        createdAt,
        updatedAt,
      ];
}
