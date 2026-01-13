import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  // Add your authentication logic here
  // For example, adding tokens to headers

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // final token = getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle auth errors (e.g., 401, 403)
    if (err.response?.statusCode == 401) {
      // Handle unauthorized access
    }
    super.onError(err, handler);
  }
}
