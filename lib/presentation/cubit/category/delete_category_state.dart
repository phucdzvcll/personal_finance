part of 'delete_category_cubit.dart';

abstract class DeleteCategoryState extends Equatable {
  const DeleteCategoryState();

  @override
  List<Object> get props => [];
}

class DeleteCategoryInitial extends DeleteCategoryState {}

class DeleteCategoryLoading extends DeleteCategoryState {}

class DeleteCategorySuccess extends DeleteCategoryState {
  final int categoryId;

  const DeleteCategorySuccess(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class DeleteCategoryError extends DeleteCategoryState {
  final String message;

  const DeleteCategoryError(this.message);

  @override
  List<Object> get props => [message];
}
