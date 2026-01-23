import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance/domain/entities/transaction_type.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionType? type;
  final int? categoryId;

  GetTransactionsParams({
    this.startDate,
    this.endDate,
    this.type,
    this.categoryId,
  });
}

@injectable
class GetTransactionsUseCase implements UseCase<List<Transaction>, GetTransactionsParams> {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(GetTransactionsParams params) async {
    return await repository.getTransactions(
      startDate: params.startDate,
      endDate: params.endDate,
      type: params.type,
      categoryId: params.categoryId,
    );
  }
}

