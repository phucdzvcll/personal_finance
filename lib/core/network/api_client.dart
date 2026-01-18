import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/auth_response_model.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/refresh_token_request.dart';
import '../../data/models/category_model.dart';
import '../../data/models/create_category_request.dart';
import '../../data/models/update_category_request.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/create_transaction_request.dart';
import '../../data/models/update_transaction_request.dart';

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
  Future<AuthResponseModel> refreshToken(@Body() RefreshTokenRequest request);

  /// Create category endpoint
  @POST('/v1/categories')
  Future<CategoryModel> createCategory(@Body() CreateCategoryRequest request);

  /// Get all categories endpoint
  @GET('/v1/categories')
  Future<List<CategoryModel>> getCategories();

  /// Get category by id endpoint
  @GET('/v1/categories/{id}')
  Future<CategoryModel> getCategoryById(@Path('id') int id);

  /// Update category endpoint
  @PATCH('/v1/categories/{id}')
  Future<CategoryModel> updateCategory(
    @Path('id') int id,
    @Body() UpdateCategoryRequest request,
  );

  /// Delete category endpoint
  @DELETE('/v1/categories/{id}')
  Future<void> deleteCategory(@Path('id') int id);

  /// Create transaction endpoint
  @POST('/v1/transactions')
  Future<TransactionModel> createTransaction(@Body() CreateTransactionRequest request);

  /// Get all transactions endpoint
  @GET('/v1/transactions')
  Future<List<TransactionModel>> getTransactions();

  /// Update transaction endpoint
  @PATCH('/v1/transactions/{id}')
  Future<TransactionModel> updateTransaction(
    @Path('id') int id,
    @Body() UpdateTransactionRequest request,
  );

  /// Delete transaction endpoint
  @DELETE('/v1/transactions/{id}')
  Future<void> deleteTransaction(@Path('id') int id);
}
