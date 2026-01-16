import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../domain/usecases/create_transaction_usecase.dart';
import '../base_cubit.dart';

part 'transaction_form_state.dart';

@injectable
class TransactionFormCubit extends BaseCubit<TransactionFormState> {
  final CreateTransactionUseCase createTransactionUseCase;

  TransactionFormCubit(this.createTransactionUseCase)
      : super(TransactionFormInitial());

  Future<void> createTransaction({
    required double amount,
    required TransactionType type,
    required int categoryId,
    required String transactionDate,
    String? note,
  }) async {
    if (amount <= 0) {
      emit(TransactionFormError('Amount must be greater than 0'));
      return;
    }

    emit(TransactionFormLoading());

    final result = await createTransactionUseCase(
      CreateTransactionParams(
        amount: amount,
        type: type,
        categoryId: categoryId,
        transactionDate: transactionDate,
        note: note,
      ),
    );

    result.fold(
      (failure) => emit(TransactionFormError(failure.message)),
      (transaction) => emit(TransactionFormSuccess(transaction)),
    );
  }

  void reset() {
    emit(TransactionFormInitial());
  }
}
