# Authentication Feature Setup

## Overview

The authentication feature has been implemented following Clean Architecture with:
- **Domain Layer**: Entities, Repository interfaces, Use Cases
- **Data Layer**: Models, Data Sources, Repository implementations
- **Presentation Layer**: Cubits, Pages, Widgets

## Features Implemented

1. **Login** - User authentication with email and password
2. **Register** - New user registration
3. **AutoRoute Navigation** - Type-safe navigation between screens

## API Endpoints

The implementation expects the following API structure:

### Login
- **Endpoint**: `POST /v1/auth/login`
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Response**:
  ```json
  {
    "user": {
      "id": "user-id",
      "email": "user@example.com",
      "name": "User Name",
      "avatar": "avatar-url"
    },
    "accessToken": "jwt-token",
    "refreshToken": "refresh-token"
  }
  ```

### Register
- **Endpoint**: `POST /v1/auth/register`
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "name": "User Name" // Optional
  }
  ```
- **Response**: Same as login

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

Run build_runner to generate:
- Freezed models (UserModel, AuthResponseModel, etc.)
- AutoRoute router
- Injectable dependency injection

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Update API Base URL

Edit `lib/core/config/app_config.dart` and update the API URLs for each environment:

```dart
static const AppConfig dev = AppConfig(
  appName: 'Personal Finance (Dev)',
  apiBaseUrl: 'http://localhost:3000/api', // Update this
  // ...
);
```

### 4. Verify API Response Format

Make sure your NestJS backend returns data in the expected format. If your API uses different field names, update the models:

- `lib/data/models/auth_response_model.dart` - Update `@JsonKey` annotations
- `lib/data/models/user_model.dart` - Update field names if needed

## Usage

### Navigation

The app uses AutoRoute for navigation. Routes are defined in `lib/core/router/app_router.dart`.

**Navigate to Register:**
```dart
context.router.push(const RegisterRoute());
```

**Navigate to Home after login:**
```dart
context.router.replaceAll([const HomeRoute()]);
```

### Using Authentication

The authentication state is managed by Cubits:

- `LoginCubit` - Handles login logic
- `RegisterCubit` - Handles registration logic

Both cubits emit states:
- `*Initial` - Initial state
- `*Loading` - Loading state
- `*Success` - Success with AuthResponse
- `*Error` - Error with message

### Example Usage in Widget

```dart
BlocConsumer<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      // Navigate to home
      context.router.replaceAll([const HomeRoute()]);
    } else if (state is LoginError) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    if (state is LoginLoading) {
      return LoadingWidget();
    }
    return LoginButton();
  },
)
```

## File Structure

```
lib/
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   └── auth_response.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── logout_usecase.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── auth_response_model.dart
│   │   ├── login_request.dart
│   │   └── register_request.dart
│   ├── datasources/
│   │   └── remote/
│   │       └── auth_remote_datasource.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── presentation/
│   ├── cubit/
│   │   └── auth/
│   │       ├── login_cubit.dart
│   │       └── register_cubit.dart
│   └── pages/
│       └── auth/
│           ├── login_page.dart
│           └── register_page.dart
└── core/
    └── router/
        └── app_router.dart
```

## Troubleshooting

### Code Generation Errors

If you see errors about missing generated files:
1. Make sure all dependencies are installed: `flutter pub get`
2. Run code generation: `dart run build_runner build --delete-conflicting-outputs`
3. If errors persist, try: `flutter clean` then `flutter pub get` then build_runner again

### API Response Format Mismatch

If your API returns different field names:
1. Check the Swagger docs at `http://localhost:3000/api/v1/docs#/`
2. Update `@JsonKey` annotations in models to match your API
3. Regenerate code

### Navigation Errors

If AutoRoute navigation doesn't work:
1. Make sure `app_router.gr.dart` is generated
2. Verify routes are defined in `app_router.dart`
3. Check that pages have `@RoutePage()` annotation

## Next Steps

1. Add form validation improvements
2. Add "Remember Me" functionality
3. Add password reset feature
4. Add social login (Google, Apple, etc.)
5. Add biometric authentication
6. Implement token refresh logic
