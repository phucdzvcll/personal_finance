# Setup Guide

## Initial Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code (required for dependency injection, models, etc.):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

   Or for watch mode (auto-regenerate on file changes):
   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

## Project Structure

The project follows Clean Architecture with the following structure:

```
lib/
├── core/           # Core utilities, error handling, network, constants
├── data/           # Data layer (datasources, models, repositories)
├── domain/         # Domain layer (entities, repositories, usecases)
├── presentation/   # Presentation layer (cubit, pages, widgets)
├── di/             # Dependency injection setup
├── app.dart        # App configuration
└── main.dart       # Entry point
```

## Adding New Features

### 1. Create Entity (Domain Layer)
```dart
// lib/domain/entities/user.dart
class User extends BaseEntity {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
  
  @override
  List<Object> get props => [id, name];
}
```

### 2. Create Model (Data Layer)
```dart
// lib/data/models/user_model.dart
@freezed
class UserModel extends BaseModel<User> {
  const factory UserModel({
    required String id,
    required String name,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  @override
  User toEntity() => User(id: id, name: name);
}
```

### 3. Create Repository Interface (Domain Layer)
```dart
// lib/domain/repositories/user_repository.dart
abstract class UserRepository extends BaseRepository {
  Future<Either<Failure, User>> getUser(String id);
}
```

### 4. Implement Repository (Data Layer)
```dart
// lib/data/repositories/user_repository_impl.dart
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;
  
  UserRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    // Implementation
  }
}
```

### 5. Create Use Case (Domain Layer)
```dart
// lib/domain/usecases/get_user.dart
@injectable
class GetUser implements UseCase<User, String> {
  final UserRepository repository;
  
  GetUser(this.repository);
  
  @override
  Future<Either<Failure, User>> call(String params) async {
    return await repository.getUser(params);
  }
}
```

### 6. Create Cubit (Presentation Layer)
```dart
// lib/presentation/cubit/user_cubit.dart
@injectable
class UserCubit extends BaseCubit<UserState> {
  final GetUser getUser;
  
  UserCubit(this.getUser) : super(UserInitial());
  
  Future<void> loadUser(String id) async {
    emit(UserLoading());
    final result = await getUser(id);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }
}
```

### 7. Create Page (Presentation Layer)
```dart
// lib/presentation/pages/user/user_page.dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserCubit>()..loadUser('123'),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return LoadingWidget();
          if (state is UserError) return ErrorDisplayWidget(message: state.message);
          if (state is UserLoaded) {
            return Text(state.user.name);
          }
          return Container();
        },
      ),
    );
  }
}
```

## Configuration

### Update API Base URL
Edit `lib/core/constants/api_constants.dart` and update the `baseUrl` to match your NestJS backend.

### Update Theme
Edit `lib/app.dart` to customize the theme using `FlexColorScheme`.

## Running the App

```bash
flutter run
```

## Code Generation

After making changes to:
- Models with `@freezed`
- Repositories with `@injectable`
- API clients with `@RestApi`

Run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
