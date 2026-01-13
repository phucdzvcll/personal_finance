import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> login(String email, String password) async {
    // Validate inputs
    if (email.isEmpty) {
      emit(LoginError('Please enter your email'));
      return;
    }

    if (!InputValidator.isValidEmail(email)) {
      emit(LoginError('Please enter a valid email'));
      return;
    }

    if (password.isEmpty) {
      emit(LoginError('Please enter your password'));
      return;
    }

    emit(LoginLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
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
