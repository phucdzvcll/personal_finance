part of 'transaction_form_cubit.dart';

abstract class TransactionFormState extends Equatable {
  const TransactionFormState();

  @override
  List<Object?> get props => [];
}

class TransactionFormInitial extends TransactionFormState {}

class TransactionFormLoadingCategories extends TransactionFormState {}

class TransactionFormCategoriesLoaded extends TransactionFormState {
  final List<Category> categories;

  const TransactionFormCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class TransactionFormCategoriesError extends TransactionFormState {
  final String message;

  const TransactionFormCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class TransactionFormLoading extends TransactionFormState {}

class TransactionFormSuccess extends TransactionFormState {
  final Transaction transaction;

  const TransactionFormSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionFormError extends TransactionFormState {
  final String message;

  const TransactionFormError(this.message);

  @override
  List<Object?> get props => [message];
}
