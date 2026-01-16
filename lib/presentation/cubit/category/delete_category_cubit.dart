import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/delete_category_usecase.dart';
import '../base_cubit.dart';

part 'delete_category_state.dart';

@injectable
class DeleteCategoryCubit extends BaseCubit<DeleteCategoryState> {
  final DeleteCategoryUseCase deleteCategoryUseCase;

  DeleteCategoryCubit(this.deleteCategoryUseCase) : super(DeleteCategoryInitial());

  Future<void> deleteCategory(int id) async {
    emit(DeleteCategoryLoading());

    final result = await deleteCategoryUseCase(id);

    result.fold(
      (failure) => emit(DeleteCategoryError(failure.message)),
      (_) => emit(DeleteCategorySuccess(id)),
    );
  }

  void reset() {
    emit(DeleteCategoryInitial());
  }
}
