import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import 'category_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const TransactionModel._();

  const factory TransactionModel({
    required int id,
    required double amount,
    required String type,
    required int categoryId,
    required String transactionDate,
    String? note,
    CategoryModel? category,
    required String createdAt,
    required String updatedAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      type: TransactionType.fromString(type),
      categoryId: categoryId,
      transactionDate: transactionDate,
      note: note,
      category: category?.toEntity(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
