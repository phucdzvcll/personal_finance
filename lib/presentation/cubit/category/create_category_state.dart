part of 'create_category_cubit.dart';

abstract class CreateCategoryState extends Equatable {
  const CreateCategoryState();

  @override
  List<Object?> get props => [];
}

class CreateCategoryInitial extends CreateCategoryState {}

class CreateCategoryLoading extends CreateCategoryState {}

class CreateCategorySuccess extends CreateCategoryState {
  final Category category;

  const CreateCategorySuccess(this.category);

  @override
  List<Object?> get props => [category];
}

class CreateCategoryError extends CreateCategoryState {
  final String message;

  const CreateCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
