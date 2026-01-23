import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finance/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:personal_finance/data/models/create_transaction_request.dart';
import 'package:personal_finance/data/models/update_transaction_request.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../domain/repositories/transaction_repository.dart';
import 'base_repository_impl.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl extends BaseRepositoryImpl
    implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Transaction>> createTransaction({
    required double amount,
    required TransactionType type,
    required int categoryId,
    required String transactionDate,
    String? note,
  }) async {
    try {
      final request = CreateTransactionRequest(
        amount: amount,
        type: type.value,
        categoryId: categoryId,
        transactionDate: transactionDate,
        note: note,
      );
      final transactionModel = await remoteDataSource.createTransaction(request);
      return Right(transactionModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    int? categoryId,
  }) async {
    try {
      final transactionModels = await remoteDataSource.getTransactions(
        startDate: startDate,
        endDate: endDate,
        type: type,
        categoryId: categoryId,
      );
      final transactions = transactionModels.map((model) => model.toEntity()).toList();
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction({
    required int id,
    required double amount,
    required TransactionType type,
    required int categoryId,
    required String transactionDate,
    String? note,
  }) async {
    try {
      final request = UpdateTransactionRequest(
        amount: amount,
        type: type.value,
        categoryId: categoryId,
        transactionDate: transactionDate,
        note: note,
      );
      final transactionModel = await remoteDataSource.updateTransaction(id, request);
      return Right(transactionModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(int id) async {
    try {
      await remoteDataSource.deleteTransaction(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
