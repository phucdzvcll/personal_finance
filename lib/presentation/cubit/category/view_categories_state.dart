part of 'view_categories_cubit.dart';

abstract class ViewCategoriesState extends Equatable {
  const ViewCategoriesState();

  @override
  List<Object?> get props => [];
}

class ViewCategoriesInitial extends ViewCategoriesState {}

class ViewCategoriesLoading extends ViewCategoriesState {}

class ViewCategoriesSuccess extends ViewCategoriesState {
  final List<Category> categories;

  const ViewCategoriesSuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ViewCategoriesError extends ViewCategoriesState {
  final String message;

  const ViewCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ViewCategoriesDeleting extends ViewCategoriesState {
  final List<Category> categories;
  final int deletingId;

  const ViewCategoriesDeleting(this.categories, this.deletingId);

  @override
  List<Object?> get props => [categories, deletingId];
}

class ViewCategoriesDeleteSuccess extends ViewCategoriesState {
  final List<Category> categories;
  final int deletedId;

  const ViewCategoriesDeleteSuccess(this.categories, this.deletedId);

  @override
  List<Object?> get props => [categories, deletedId];
}

class ViewCategoriesDeleteError extends ViewCategoriesState {
  final List<Category> categories;
  final String message;

  const ViewCategoriesDeleteError(this.categories, this.message);

  @override
  List<Object?> get props => [categories, message];
}
