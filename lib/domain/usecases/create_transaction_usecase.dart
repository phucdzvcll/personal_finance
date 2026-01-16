import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/transaction.dart';
import '../entities/transaction_type.dart';
import '../repositories/transaction_repository.dart';

class CreateTransactionParams {
  final double amount;
  final TransactionType type;
  final int categoryId;
  final String transactionDate;
  final String? note;

  CreateTransactionParams({
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.transactionDate,
    this.note,
  });
}

@injectable
class CreateTransactionUseCase
    implements UseCase<Transaction, CreateTransactionParams> {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(CreateTransactionParams params) async {
    return await repository.createTransaction(
      amount: params.amount,
      type: params.type,
      categoryId: params.categoryId,
      transactionDate: params.transactionDate,
      note: params.note,
    );
  }
}
