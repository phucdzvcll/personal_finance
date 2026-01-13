# Retrofit & Freezed Setup Guide

## Overview

This project now uses **Retrofit** for type-safe API calls and **Freezed** for immutable data models.

## What's Configured

### 1. Dependencies
- ✅ `retrofit: ^4.0.3` - Type-safe HTTP client
- ✅ `retrofit_generator: ^9.0.0` - Code generator for Retrofit
- ✅ `freezed: ^2.4.6` - Immutable data classes
- ✅ `freezed_annotation: ^2.4.1` - Annotations for Freezed
- ✅ `json_serializable: ^6.7.1` - JSON serialization

### 2. API Client (`lib/core/network/api_client.dart`)

```dart
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST('/v1/auth/login')
  Future<AuthResponseModel> login(@Body() LoginRequest request);

  @POST('/v1/auth/register')
  Future<AuthResponseModel> register(@Body() RegisterRequest request);

  @POST('/v1/auth/refresh')
  Future<AuthResponseModel> refreshToken(@Body() Map<String, dynamic> request);
}
```

### 3. Models Using Freezed

All models use Freezed for immutability:

- `UserModel` - User data model
- `AuthResponseModel` - Authentication response
- `LoginRequest` - Login request body
- `RegisterRequest` - Registration request body

### 4. Data Source Updated

`AuthRemoteDataSource` now uses `ApiClient` (Retrofit) instead of direct Dio calls:

```dart
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient; // ✅ Using Retrofit
  
  Future<AuthResponseModel> login(LoginRequest request) async {
    return await apiClient.login(request); // ✅ Type-safe call
  }
}
```

## Setup Steps

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

```bash
make gen
# or
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- `*.freezed.dart` files for Freezed models
- `*.g.dart` files for JSON serialization
- `api_client.g.dart` for Retrofit implementation

### 3. Verify Generation

After generation, you should see:
- `lib/core/network/api_client.g.dart` - Retrofit implementation
- `lib/data/models/*.freezed.dart` - Freezed implementations
- `lib/data/models/*.g.dart` - JSON serialization

## Adding New API Endpoints

### Step 1: Add Endpoint to ApiClient

```dart
@RestApi()
abstract class ApiClient {
  // ... existing endpoints

  @GET('/v1/users')
  Future<List<UserModel>> getUsers();

  @GET('/v1/users/{id}')
  Future<UserModel> getUser(@Path('id') String id);

  @POST('/v1/users')
  Future<UserModel> createUser(@Body() CreateUserRequest request);
}
```

### Step 2: Create Request/Response Models with Freezed

```dart
@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String email,
    required String name,
  }) = _CreateUserRequest;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);
}
```

### Step 3: Update Data Source

```dart
@override
Future<List<UserModel>> getUsers() async {
  try {
    return await apiClient.getUsers();
  } on DioException catch (e) {
    // Handle errors
  }
}
```

### Step 4: Regenerate Code

```bash
make gen
```

## Retrofit Annotations

### HTTP Methods
- `@GET('/path')` - GET request
- `@POST('/path')` - POST request
- `@PUT('/path')` - PUT request
- `@DELETE('/path')` - DELETE request
- `@PATCH('/path')` - PATCH request

### Parameters
- `@Path('id')` - Path parameter
- `@Query('name')` - Query parameter
- `@Body()` - Request body
- `@Header('Authorization')` - Header parameter
- `@Field('name')` - Form field (for form-urlencoded)

### Examples

```dart
// Path parameter
@GET('/users/{id}')
Future<UserModel> getUser(@Path('id') String id);

// Query parameters
@GET('/users')
Future<List<UserModel>> getUsers(
  @Query('page') int page,
  @Query('limit') int limit,
);

// Request body
@POST('/users')
Future<UserModel> createUser(@Body() CreateUserRequest request);

// Headers
@GET('/profile')
@Headers({'Authorization': 'Bearer token'})
Future<UserModel> getProfile();
```

## Freezed Models

### Basic Model

```dart
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    String? name,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### Model with Custom JSON Keys

```dart
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const AuthResponseModel._();

  const factory AuthResponseModel({
    required UserModel user,
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
```

### Converting to Entity

```dart
@freezed
class UserModel with _$UserModel {
  // ... factory and fromJson

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
    );
  }
}
```

## Benefits

### Retrofit
- ✅ **Type-safe** - Compile-time checking of API calls
- ✅ **Less boilerplate** - No manual JSON parsing
- ✅ **Auto-generated** - Implementation generated automatically
- ✅ **Clean code** - Declarative API definitions

### Freezed
- ✅ **Immutable** - Models can't be modified after creation
- ✅ **Type-safe** - Compile-time guarantees
- ✅ **CopyWith** - Easy to create modified copies
- ✅ **Equality** - Automatic equality comparison
- ✅ **JSON serialization** - Auto-generated from/to JSON

## Troubleshooting

### "api_client.g.dart not found"
Run code generation:
```bash
make gen
```

### "Type not registered in GetIt"
Make sure `ApiClient` is provided in `DioModule`:
```dart
@module
abstract class DioModule {
  @lazySingleton
  ApiClient provideApiClient(@Named('dio') Dio dio) => ApiClient(dio);
}
```

### "Freezed model errors"
Ensure models have:
- `part '*.freezed.dart';` and `part '*.g.dart';`
- `@freezed` annotation
- `with _$ModelName` mixin
- Factory constructor with `const factory`
- `fromJson` factory method

### Regenerating After Changes

After modifying:
- API endpoints → Run `make gen`
- Freezed models → Run `make gen`
- Injectable classes → Run `make gen`

## Example: Complete Flow

1. **Define API endpoint:**
```dart
@POST('/v1/auth/login')
Future<AuthResponseModel> login(@Body() LoginRequest request);
```

2. **Use in data source:**
```dart
final authResponse = await apiClient.login(request);
```

3. **Convert to entity:**
```dart
return authResponse.toEntity();
```

4. **Use in repository:**
```dart
final result = await remoteDataSource.login(request);
return Right(result.toEntity());
```

## Next Steps

1. Run `make gen` to generate all code
2. Test the login/register functionality
3. Add more API endpoints as needed
4. Follow the same pattern for new features
