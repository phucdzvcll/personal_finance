part of 'transaction_form_cubit.dart';

abstract class TransactionFormState extends Equatable {
  const TransactionFormState();

  @override
  List<Object?> get props => [];
}

class TransactionFormInitial extends TransactionFormState {}

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
