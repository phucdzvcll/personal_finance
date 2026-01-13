# Flutter Development Rules

This document contains important rules and patterns to follow when developing Flutter features in this project.

## Table of Contents

1. [BLoC Provider Context Access](#bloc-provider-context-access)
2. [Clean Architecture](#clean-architecture)
3. [Dependency Injection](#dependency-injection)

---

## BLoC Provider Context Access

### ⚠️ Critical Rule

**NEVER use State class's `context` to access BlocProvider or Provider instances.**

### The Problem

When you create a `BlocProvider` in the `build` method, the State's `context` is outside the provider's widget tree. Accessing providers using this context will throw `ProviderNotFoundException`.

### ✅ Correct Pattern

```dart
class _MyPageState extends State<MyPage> {
  void _handleAction(BuildContext context) {
    // ✅ Context passed from within BlocProvider tree
    context.read<MyCubit>().doSomething();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyCubit>(),
      child: BlocBuilder<MyCubit, MyState>(
        builder: (context, state) {
          return ElevatedButton(
            // ✅ Pass context from builder
            onPressed: () => _handleAction(context),
            child: Text('Action'),
          );
        },
      ),
    );
  }
}
```

### ❌ Wrong Pattern

```dart
class _MyPageState extends State<MyPage> {
  void _handleAction() {
    // ❌ WRONG: State's context is outside BlocProvider tree
    context.read<MyCubit>().doSomething();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyCubit>(),
      child: ElevatedButton(
        // ❌ Wrong: No context passed
        onPressed: _handleAction,
        child: Text('Action'),
      ),
    );
  }
}
```

### Key Points

1. **Always pass `BuildContext` as parameter** to methods that need to access providers
2. **Use context from builder/listener** - These contexts are inside the provider tree
3. **Use arrow functions** - `onPressed: () => _handleAction(context)` instead of `onPressed: _handleAction`

**See detailed guide:** `FLUTTER_BLOC_PROVIDER_CONTEXT.md`

---

## Clean Architecture

### Layer Dependencies

- **Presentation** → **Domain** ✅
- **Data** → **Domain** ✅
- **Domain** → **Nothing** ✅
- **Presentation** → **Data** ❌ (Never!)

### File Organization

```
lib/
├── domain/          # Business logic (entities, repositories, usecases)
├── data/            # Data sources (models, datasources, repository impls)
├── presentation/    # UI (pages, widgets, cubits)
└── core/            # Shared utilities
```

### Use Cases

- All use cases must extend `UseCase<Type, Params>` or `UseCaseNoParams<Type>`
- Use cases should be annotated with `@injectable`
- Use cases should only depend on repository interfaces (domain layer)

### Repositories

- Repository interfaces go in `domain/repositories/`
- Repository implementations go in `data/repositories/`
- Implementations must be annotated with `@LazySingleton(as: RepositoryInterface)`

---

## Dependency Injection

### Injectable Annotations

- **@injectable** - For classes that can be auto-registered
- **@LazySingleton** - For singletons (created on first access)
- **@singleton** - For eager singletons (created immediately)
- **@module** - For external dependencies (like SharedPreferences)

### SharedPreferences Pattern

```dart
// In injection.dart - Register manually before getIt.init()
final sharedPreferences = await SharedPreferences.getInstance();
getIt.registerSingleton<SharedPreferences>(sharedPreferences);

// Then call
await getIt.init();
```

### Code Generation

Always run code generation after adding new injectable classes:

```bash
make gen
# or
dart run build_runner build --delete-conflicting-outputs
```

---

## Navigation (AutoRoute)

### Route Definition

- All pages must have `@RoutePage()` annotation
- Routes are defined in `lib/core/router/app_router.dart`
- Use `context.router.push()`, `context.router.replace()`, etc.

### Navigation Examples

```dart
// Push new route
context.router.push(const RegisterRoute());

// Replace current route
context.router.replace(const HomeRoute());

// Replace all routes (clear stack)
context.router.replaceAll([const HomeRoute()]);
```

---

## State Management (BLoC/Cubit)

### Cubit Pattern

- All cubits extend `BaseCubit<State>`
- States extend `Equatable` for comparison
- Use `BlocProvider` for providing cubits
- Use `BlocConsumer` for listening and building

### State Naming

- `*Initial` - Initial state
- `*Loading` - Loading state
- `*Success` - Success state with data
- `*Error` - Error state with message

### Example

```dart
// State
abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final AuthResponse authResponse;
  const LoginSuccess(this.authResponse);
}
class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}

// Cubit
@injectable
class LoginCubit extends BaseCubit<LoginState> {
  final LoginUseCase loginUseCase;
  
  LoginCubit(this.loginUseCase) : super(LoginInitial());
  
  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final result = await loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (authResponse) => emit(LoginSuccess(authResponse)),
    );
  }
}
```

---

## Error Handling

### Failure Types

- `ServerFailure` - API/server errors
- `NetworkFailure` - Network connectivity issues
- `CacheFailure` - Local storage errors
- `ValidationFailure` - Input validation errors
- `UnknownFailure` - Unexpected errors

### Error Handling Pattern

```dart
try {
  final result = await repository.getData();
  return Right(result);
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} on NetworkException catch (e) {
  return Left(NetworkFailure(e.message));
} catch (e) {
  return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
}
```

---

## Code Generation Checklist

Before committing, ensure:

- [ ] Run `make gen` to generate all code
- [ ] Check for linter errors: `make lint`
- [ ] Format code: `make format`
- [ ] Run tests: `make test`

---

## Quick Reference

### Common Commands

```bash
make gen          # Generate code
make run-dev      # Run dev flavor
make format       # Format code
make lint         # Run linter
make test         # Run tests
```

### Common Patterns

- **Accessing Cubit**: Always pass context from builder
- **Navigation**: Use `context.router` from AutoRoute
- **Error Handling**: Use Either<Failure, Success> pattern
- **DI**: Annotate with `@injectable` and run code generation
