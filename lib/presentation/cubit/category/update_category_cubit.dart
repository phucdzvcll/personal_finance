import 'package:injectable/injectable.dart';
import '../../../domain/entities/category_type.dart';
import '../../../domain/usecases/update_category_usecase.dart';
import '../base_cubit.dart';
import 'create_category_cubit.dart';

@injectable
class UpdateCategoryCubit extends BaseCubit<CreateCategoryState> {
  final UpdateCategoryUseCase updateCategoryUseCase;

  UpdateCategoryCubit(this.updateCategoryUseCase) : super(CreateCategoryInitial());

  Future<void> updateCategory({
    required int id,
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
  }) async {
    if (name.trim().isEmpty) {
      emit(CreateCategoryError('Category name is required'));
      return;
    }

    emit(CreateCategoryLoading());

    final result = await updateCategoryUseCase(
      UpdateCategoryParams(
        id: id,
        name: name.trim(),
        type: type,
        icon: icon?.trim(),
        color: color?.trim(),
      ),
    );

    result.fold(
      (failure) => emit(CreateCategoryError(failure.message)),
      (category) => emit(CreateCategorySuccess(category)),
    );
  }

  void reset() {
    emit(CreateCategoryInitial());
  }
}
