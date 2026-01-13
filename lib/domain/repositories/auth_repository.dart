import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth_response.dart';
import 'base_repository.dart';

abstract class AuthRepository extends BaseRepository {
  /// Login with email and password
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, AuthResponse>> register({
    required String email,
    required String password,
    String? name,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get current user token
  Future<String?> getToken();
}
