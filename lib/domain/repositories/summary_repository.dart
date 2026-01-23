import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/summary.dart';
import 'base_repository.dart';

abstract class SummaryRepository extends BaseRepository {
  /// Get monthly summary
  Future<Either<Failure, Summary>> getMonthlySummary(int year, int month);
}
