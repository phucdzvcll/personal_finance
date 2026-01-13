import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: '') // Base URL is set in Dio's BaseOptions
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  /// Login endpoint
  @POST('/v1/auth/login')
  Future<AuthResponseModel> login(@Body() LoginRequest request);

  /// Register endpoint
  @POST('/v1/auth/register')
  Future<AuthResponseModel> register(@Body() RegisterRequest request);

  /// Refresh token endpoint
  @POST('/v1/auth/refresh')
  Future<AuthResponseModel> refreshToken(@Body() Map<String, dynamic> request);
}
