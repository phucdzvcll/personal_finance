import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../domain/usecases/delete_transaction_usecase.dart';
import '../../../domain/usecases/get_transactions_usecase.dart';
import '../base_cubit.dart';

part 'view_transactions_state.dart';

@injectable
class ViewTransactionsCubit extends BaseCubit<ViewTransactionsState> {
  final GetTransactionsUseCase getTransactionsUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;

  ViewTransactionsCubit(
    this.getTransactionsUseCase,
    this.deleteTransactionUseCase,
  ) : super(ViewTransactionsInitial());

  DateTime? _startDate;
  DateTime? _endDate;
  TransactionType? _type;
  int? _categoryId;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  TransactionType? get type => _type;
  int? get categoryId => _categoryId;

  Future<void> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    int? categoryId,
  }) async {
    _startDate = startDate;
    _endDate = endDate;
    _type = type;
    _categoryId = categoryId;
    
    emit(ViewTransactionsLoading());

    final result = await getTransactionsUseCase(
      GetTransactionsParams(
        startDate: startDate,
        endDate: endDate,
        type: type,
        categoryId: categoryId,
      ),
    );

    result.fold(
      (failure) => emit(ViewTransactionsError(failure.message)),
      (transactions) => emit(ViewTransactionsSuccess(transactions)),
    );
  }

  Future<void> deleteTransaction(int id) async {
    // Get current transactions if we have them
    List<Transaction> currentTransactions = [];
    if (state is ViewTransactionsSuccess) {
      currentTransactions = (state as ViewTransactionsSuccess).transactions;
    } else if (state is ViewTransactionsDeleteError) {
      currentTransactions = (state as ViewTransactionsDeleteError).transactions;
    }

    // Emit deleting state
    emit(ViewTransactionsDeleting(currentTransactions, id));

    final result = await deleteTransactionUseCase(id);

    result.fold(
      (failure) => emit(ViewTransactionsDeleteError(currentTransactions, failure.message)),
      (_) {
        // Remove deleted transaction from list and emit success
        final updatedTransactions = currentTransactions.where((t) => t.id != id).toList();
        emit(ViewTransactionsDeleteSuccess(updatedTransactions, id));
        // Automatically refresh to get latest data
        getTransactions(
          startDate: _startDate,
          endDate: _endDate,
          type: _type,
          categoryId: _categoryId,
        );
      },
    );
  }

  void reset() {
    emit(ViewTransactionsInitial());
  }
}

