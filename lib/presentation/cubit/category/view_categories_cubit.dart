import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/delete_category_usecase.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../base_cubit.dart';

part 'view_categories_state.dart';

@injectable
class ViewCategoriesCubit extends BaseCubit<ViewCategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  ViewCategoriesCubit(
    this.getCategoriesUseCase,
    this.deleteCategoryUseCase,
  ) : super(ViewCategoriesInitial());

  Future<void> getCategories() async {
    emit(ViewCategoriesLoading());

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) => emit(ViewCategoriesError(failure.message)),
      (categories) => emit(ViewCategoriesSuccess(categories)),
    );
  }

  Future<void> deleteCategory(int id) async {
    // Get current categories if we have them
    List<Category> currentCategories = [];
    if (state is ViewCategoriesSuccess) {
      currentCategories = (state as ViewCategoriesSuccess).categories;
    } else if (state is ViewCategoriesDeleteError) {
      currentCategories = (state as ViewCategoriesDeleteError).categories;
    }

    // Emit deleting state
    emit(ViewCategoriesDeleting(currentCategories, id));

    final result = await deleteCategoryUseCase(id);

    result.fold(
      (failure) => emit(ViewCategoriesDeleteError(currentCategories, failure.message)),
      (_) {
        // Remove deleted category from list and emit success
        final updatedCategories = currentCategories.where((c) => c.id != id).toList();
        emit(ViewCategoriesDeleteSuccess(updatedCategories, id));
        // Automatically refresh to get latest data
        getCategories();
      },
    );
  }

  void reset() {
    emit(ViewCategoriesInitial());
  }
}
