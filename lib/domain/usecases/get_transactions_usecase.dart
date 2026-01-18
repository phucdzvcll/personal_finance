import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

@injectable
class GetTransactionsUseCase implements UseCaseNoParams<List<Transaction>> {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call() async {
    return await repository.getTransactions();
  }
}

