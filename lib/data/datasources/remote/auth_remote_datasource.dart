import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../local/shared_prefs_datasource.dart';
import '../../models/auth_response_model.dart';
import '../../models/login_request.dart';
import '../../models/register_request.dart';
import 'remote_datasource.dart';

abstract class AuthRemoteDataSource extends RemoteDataSource {
  Future<AuthResponseModel> login(LoginRequest request);

  Future<AuthResponseModel> register(RegisterRequest request);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final SharedPrefsDataSource sharedPrefsDataSource;

  AuthRemoteDataSourceImpl(
    this.apiClient,
    this.sharedPrefsDataSource,
  );

  @override
  Future<AuthResponseModel> login(LoginRequest request) async {
    try {
      final authResponse = await apiClient.login(request);

      // Save tokens
      await sharedPrefsDataSource.saveToken(authResponse.accessToken);
      if (authResponse.refreshToken != null) {
        await sharedPrefsDataSource.saveRefreshToken(
          authResponse.refreshToken!,
        );
      }
      await sharedPrefsDataSource.saveUserId(authResponse.user.id);

      return authResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Login failed'
            : 'Login failed';
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequest request) async {
    try {
      final authResponse = await apiClient.register(request);

      // Save tokens
      await sharedPrefsDataSource.saveToken(authResponse.accessToken);
      if (authResponse.refreshToken != null) {
        await sharedPrefsDataSource.saveRefreshToken(
          authResponse.refreshToken!,
        );
      }
      await sharedPrefsDataSource.saveUserId(authResponse.user.id);

      return authResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Registration failed'
            : 'Registration failed';
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
