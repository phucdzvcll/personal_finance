import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_transaction_request.freezed.dart';
part 'update_transaction_request.g.dart';

@freezed
class UpdateTransactionRequest with _$UpdateTransactionRequest {
  const UpdateTransactionRequest._();

  const factory UpdateTransactionRequest({
    double? amount,
    String? type,
    int? categoryId,
    String? transactionDate,
    String? note,
  }) = _UpdateTransactionRequest;

  factory UpdateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTransactionRequestFromJson(json);
}

