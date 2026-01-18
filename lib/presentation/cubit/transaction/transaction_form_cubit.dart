import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_type.dart';
import '../../../domain/usecases/create_transaction_usecase.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../../../domain/usecases/update_transaction_usecase.dart';
import '../base_cubit.dart';

part 'transaction_form_state.dart';

@injectable
class TransactionFormCubit extends BaseCubit<TransactionFormState> {
  final CreateTransactionUseCase createTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  TransactionFormCubit(
    this.createTransactionUseCase,
    this.updateTransactionUseCase,
    this.getCategoriesUseCase,
  ) : super(TransactionFormInitial());

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

  Future<void> updateTransaction({
    required int id,
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

    final result = await updateTransactionUseCase(
      UpdateTransactionParams(
        id: id,
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

  Future<void> loadCategories() async {
    emit(TransactionFormLoadingCategories());

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) => emit(TransactionFormCategoriesError(failure.message)),
      (categories) => emit(TransactionFormCategoriesLoaded(categories)),
    );
  }

  void reset() {
    emit(TransactionFormInitial());
  }
}
