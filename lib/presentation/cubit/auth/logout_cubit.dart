import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../base_cubit.dart';

part 'logout_state.dart';

@injectable
class LogoutCubit extends BaseCubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(LogoutError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }

  void reset() {
    emit(LogoutInitial());
  }
}
