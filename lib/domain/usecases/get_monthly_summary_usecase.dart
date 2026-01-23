import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/summary.dart';
import '../repositories/summary_repository.dart';

class GetMonthlySummaryParams {
  final int year;
  final int month;

  GetMonthlySummaryParams({
    required this.year,
    required this.month,
  });
}

@injectable
class GetMonthlySummaryUseCase
    implements UseCase<Summary, GetMonthlySummaryParams> {
  final SummaryRepository repository;

  GetMonthlySummaryUseCase(this.repository);

  @override
  Future<Either<Failure, Summary>> call(GetMonthlySummaryParams params) async {
    return await repository.getMonthlySummary(params.year, params.month);
  }
}
