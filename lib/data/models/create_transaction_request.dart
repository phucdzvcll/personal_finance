import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_transaction_request.freezed.dart';
part 'create_transaction_request.g.dart';

@freezed
class CreateTransactionRequest with _$CreateTransactionRequest {
  const CreateTransactionRequest._();

  const factory CreateTransactionRequest({
    required double amount,
    required String type,
    required int categoryId,
    required String transactionDate,
    String? note,
  }) = _CreateTransactionRequest;

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionRequestFromJson(json);
}
