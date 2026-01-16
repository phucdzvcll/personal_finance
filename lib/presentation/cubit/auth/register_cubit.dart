import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../core/utils/input_validator.dart';
import '../../../domain/entities/auth_response.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../base_cubit.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends BaseCubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    String? name,
  }) async {
    // Validate inputs
    if (email.isEmpty) {
      emit(RegisterError('Please enter your email'));
      return;
    }

    if (!InputValidator.isValidEmail(email)) {
      emit(RegisterError('Please enter a valid email'));
      return;
    }

    if (password.isEmpty) {
      emit(RegisterError('Please enter a password'));
      return;
    }

    if (password.length < 8) {
      emit(RegisterError('Password must be at least 8 characters'));
      return;
    }

    if (password != confirmPassword) {
      emit(RegisterError('Passwords do not match'));
      return;
    }

    emit(RegisterLoading());

    final result = await registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        name: name?.isEmpty ?? true ? null : name,
      ),
    );

    result.fold(
      (failure) => emit(RegisterError(failure.message)),
      (authResponse) => emit(RegisterSuccess(authResponse)),
    );
  }

  void reset() {
    emit(RegisterInitial());
  }
}
