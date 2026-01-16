import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../base_cubit.dart';

part 'get_categories_state.dart';

@injectable
class GetCategoriesCubit extends BaseCubit<GetCategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  GetCategoriesCubit(this.getCategoriesUseCase) : super(GetCategoriesInitial());

  Future<void> getCategories() async {
    emit(GetCategoriesLoading());

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) => emit(GetCategoriesError(failure.message)),
      (categories) => emit(GetCategoriesSuccess(categories)),
    );
  }

  void reset() {
    emit(GetCategoriesInitial());
  }
}
