import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginParams extends Equatable {
  final String usernameOrEmail;
  final String password;

  const LoginParams({
    required this.usernameOrEmail,
    required this.password,
  });

  @override
  List<Object> get props => [usernameOrEmail, password];
}

@injectable
class LoginUseCase implements UseCase<AuthResponse, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResponse>> call(LoginParams params) async {
    return await repository.login(
      usernameOrEmail: params.usernameOrEmail,
      password: params.password,
    );
  }
}
