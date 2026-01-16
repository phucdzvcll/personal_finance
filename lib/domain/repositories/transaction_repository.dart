import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/transaction.dart';
import '../entities/transaction_type.dart';
import 'base_repository.dart';

abstract class TransactionRepository extends BaseRepository {
  /// Create transaction
  Future<Either<Failure, Transaction>> createTransaction({
    required double amount,
    required TransactionType type,
    required int categoryId,
    required String transactionDate,
    String? note,
  });
}
