import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_constants.dart';
import 'api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

@lazySingleton
class DioClient {
  late Dio _dio;

  DioClient(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) {
    _dio = Dio(
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

    _dio.interceptors.addAll([
      loggingInterceptor,
      authInterceptor,
    ]);
  }

  Dio get dio => _dio;
}

// Provide Dio instance with named injection
@module
abstract class DioModule {
  @Named('dio')
  @lazySingleton
  Dio provideDio(DioClient dioClient) => dioClient.dio;
  
  // Provide ApiClient (Retrofit)
  @lazySingleton
  ApiClient provideApiClient(@Named('dio') Dio dio) => ApiClient(dio);
}
