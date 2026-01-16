import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/category_type.dart';
import '../../../domain/usecases/create_category_usecase.dart';
import '../../../domain/usecases/update_category_usecase.dart';
import '../base_cubit.dart';

part 'category_form_state.dart';

@injectable
class CategoryFormCubit extends BaseCubit<CategoryFormState> {
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;

  CategoryFormCubit(
    this.createCategoryUseCase,
    this.updateCategoryUseCase,
  ) : super(CategoryFormInitial());

  Future<void> createCategory({
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
  }) async {
    if (name.trim().isEmpty) {
      emit(CategoryFormError('Category name is required'));
      return;
    }

    emit(CategoryFormLoading());

    final result = await createCategoryUseCase(
      CreateCategoryParams(
        name: name.trim(),
        type: type,
        icon: icon?.trim(),
        color: color?.trim(),
      ),
    );

    result.fold(
      (failure) => emit(CategoryFormError(failure.message)),
      (category) => emit(CategoryFormSuccess(category)),
    );
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    required CategoryType type,
    String? icon,
    String? color,
  }) async {
    if (name.trim().isEmpty) {
      emit(CategoryFormError('Category name is required'));
      return;
    }

    emit(CategoryFormLoading());

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
      (failure) => emit(CategoryFormError(failure.message)),
      (category) => emit(CategoryFormSuccess(category)),
    );
  }

  void reset() {
    emit(CategoryFormInitial());
  }
}
