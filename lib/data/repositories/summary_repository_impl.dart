import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/summary.dart';
import '../../../domain/repositories/summary_repository.dart';
import '../datasources/remote/summary_remote_datasource.dart';
import 'base_repository_impl.dart';

@LazySingleton(as: SummaryRepository)
class SummaryRepositoryImpl extends BaseRepositoryImpl
    implements SummaryRepository {
  final SummaryRemoteDataSource remoteDataSource;

  SummaryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Summary>> getMonthlySummary(int year, int month) async {
    try {
      final summaryModel = await remoteDataSource.getMonthlySummary(year, month);
      return Right(summaryModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
