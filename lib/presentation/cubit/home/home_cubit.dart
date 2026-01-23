import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/summary.dart';
import '../../../domain/usecases/get_monthly_summary_usecase.dart';
import '../base_cubit.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final GetMonthlySummaryUseCase getMonthlySummaryUseCase;

  HomeCubit(this.getMonthlySummaryUseCase) : super(HomeInitial());

  Future<void> getMonthlySummary(int year, int month) async {
    emit(HomeLoading());

    final result = await getMonthlySummaryUseCase(
      GetMonthlySummaryParams(year: year, month: month),
    );

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (summary) => emit(HomeSuccess(summary)),
    );
  }

  void reset() {
    emit(HomeInitial());
  }
}
