part of 'category_form_cubit.dart';

abstract class CategoryFormState extends Equatable {
  const CategoryFormState();

  @override
  List<Object?> get props => [];
}

class CategoryFormInitial extends CategoryFormState {}

class CategoryFormLoading extends CategoryFormState {}

class CategoryFormSuccess extends CategoryFormState {
  final Category category;

  const CategoryFormSuccess(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryFormError extends CategoryFormState {
  final String message;

  const CategoryFormError(this.message);

  @override
  List<Object?> get props => [message];
}
