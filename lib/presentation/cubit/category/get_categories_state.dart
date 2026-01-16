part of 'get_categories_cubit.dart';

abstract class GetCategoriesState extends Equatable {
  const GetCategoriesState();

  @override
  List<Object> get props => [];
}

class GetCategoriesInitial extends GetCategoriesState {}

class GetCategoriesLoading extends GetCategoriesState {}

class GetCategoriesSuccess extends GetCategoriesState {
  final List<Category> categories;

  const GetCategoriesSuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

class GetCategoriesError extends GetCategoriesState {
  final String message;

  const GetCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}
