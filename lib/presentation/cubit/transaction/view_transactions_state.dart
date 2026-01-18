part of 'view_transactions_cubit.dart';

abstract class ViewTransactionsState extends Equatable {
  const ViewTransactionsState();

  @override
  List<Object?> get props => [];
}

class ViewTransactionsInitial extends ViewTransactionsState {}

class ViewTransactionsLoading extends ViewTransactionsState {}

class ViewTransactionsSuccess extends ViewTransactionsState {
  final List<Transaction> transactions;

  const ViewTransactionsSuccess(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class ViewTransactionsError extends ViewTransactionsState {
  final String message;

  const ViewTransactionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ViewTransactionsDeleting extends ViewTransactionsState {
  final List<Transaction> transactions;
  final int deletingId;

  const ViewTransactionsDeleting(this.transactions, this.deletingId);

  @override
  List<Object?> get props => [transactions, deletingId];
}

class ViewTransactionsDeleteSuccess extends ViewTransactionsState {
  final List<Transaction> transactions;
  final int deletedId;

  const ViewTransactionsDeleteSuccess(this.transactions, this.deletedId);

  @override
  List<Object?> get props => [transactions, deletedId];
}

class ViewTransactionsDeleteError extends ViewTransactionsState {
  final List<Transaction> transactions;
  final String message;

  const ViewTransactionsDeleteError(this.transactions, this.message);

  @override
  List<Object?> get props => [transactions, message];
}

