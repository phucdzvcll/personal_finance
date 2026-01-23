import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../data/datasources/local/shared_prefs_datasource.dart';
import '../../../data/models/auth_response_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/auth_service.dart';
import 'dart:convert';

@injectable
class AuthInterceptor extends Interceptor {
  final SharedPrefsDataSource _sharedPrefsDataSource;
  final AuthService _authService;
  final Dio _refreshDio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  AuthInterceptor(
    this._sharedPrefsDataSource,
    this._authService,
  )
      : _refreshDio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Skip auth for login, register, and refresh endpoints
    if (_shouldSkipAuth(options.path)) {
      super.onRequest(options, handler);
      return;
    }

    // Add auth token if available
    final token = _sharedPrefsDataSource.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401 && !_shouldSkipAuth(err.requestOptions.path)) {
      // If already refreshing, queue this request
      if (_isRefreshing) {
        _pendingRequests.add(_PendingRequest(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;

      try {
        final refreshToken = _sharedPrefsDataSource.getRefreshToken();
        if (refreshToken == null) {
          // No refresh token, force logout and navigate to login
          await _authService.forceLogout();
          handler.reject(err);
          return;
        }

        // Attempt to refresh token
        final newTokens = await _refreshToken(refreshToken);
        if (newTokens == null) {
          // Refresh failed, force logout and navigate to login
          await _authService.forceLogout();
          handler.reject(err);
          return;
        }

        // Save new tokens
        await _sharedPrefsDataSource.saveToken(newTokens.accessToken);
        if (newTokens.refreshToken != null) {
          await _sharedPrefsDataSource.saveRefreshToken(newTokens.refreshToken!);
        }

        // Retry the original request with new token
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

        final response = await _refreshDio.fetch(opts);
        handler.resolve(response);

        // Process pending requests
        _processPendingRequests(newTokens.accessToken);
      } catch (e) {
        // Refresh failed, force logout and navigate to login
        await _authService.forceLogout();
        handler.reject(err);
        _rejectPendingRequests(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldSkipAuth(String path) {
    return path.contains('/v1/auth/login') ||
        path.contains('/v1/auth/register') ||
        path.contains('/v1/auth/refresh');
  }

  Future<AuthResponseModel?> _refreshToken(String refreshToken) async {
    try {
      final response = await _refreshDio.post(
        '/v1/auth/refresh',
        data: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return AuthResponseModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  Future<void> _processPendingRequests(String newToken) async {
    for (final pending in _pendingRequests) {
      try {
        pending.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await _refreshDio.fetch(pending.requestOptions);
        pending.handler.resolve(response);
      } catch (e) {
        pending.handler.reject(
          DioException(
            requestOptions: pending.requestOptions,
            error: e,
          ),
        );
      }
    }
    _pendingRequests.clear();
  }

  void _rejectPendingRequests(DioException err) {
    for (final pending in _pendingRequests) {
      pending.handler.reject(err);
    }
    _pendingRequests.clear();
  }
}

class _PendingRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _PendingRequest(this.requestOptions, this.handler);
}

