import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/category_type.dart';
import '../../../domain/usecases/create_category_usecase.dart';
import '../base_cubit.dart';

part 'create_category_state.dart';

@injectable
class CreateCategoryCubit extends BaseCubit<CreateCategoryState> {
  final CreateCategoryUseCase createCategoryUseCase;

  CreateCategoryCubit(this.createCategoryUseCase) : super(CreateCategoryInitial());

  Future<void> createCategory({
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

    final result = await createCategoryUseCase(
      CreateCategoryParams(
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
