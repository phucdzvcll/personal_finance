import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/transaction.dart';
import '../entities/transaction_type.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransactionParams {
  final int id;
  final double amount;
  final TransactionType type;
  final int categoryId;
  final String transactionDate;
  final String? note;

  UpdateTransactionParams({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.transactionDate,
    this.note,
  });
}

@injectable
class UpdateTransactionUseCase
    implements UseCase<Transaction, UpdateTransactionParams> {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(UpdateTransactionParams params) async {
    return await repository.updateTransaction(
      id: params.id,
      amount: params.amount,
      type: params.type,
      categoryId: params.categoryId,
      transactionDate: params.transactionDate,
      note: params.note,
    );
  }
}

