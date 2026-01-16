import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/input_validator.dart';
import '../../../domain/entities/auth_response.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../base_cubit.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String usernameOrEmail, String password) async {
    // Validate inputs
    if (usernameOrEmail.isEmpty) {
      emit(LoginError('Please enter your username or email'));
      return;
    }

    if (!InputValidator.isValidUsernameOrEmail(usernameOrEmail)) {
      emit(LoginError('Please enter a valid username or email'));
      return;
    }

    if (password.isEmpty) {
      emit(LoginError('Please enter your password'));
      return;
    }

    emit(LoginLoading());

    final result = await loginUseCase(
      LoginParams(usernameOrEmail: usernameOrEmail, password: password),
    );

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (authResponse) => emit(LoginSuccess(authResponse)),
    );
  }

  void reset() {
    emit(LoginInitial());
  }
}
