---
description: "Each screen/page should have only ONE cubit. Combine related functionality into a single cubit instead of using multiple cubits."
alwaysApply: false
---

# One Cubit Per Screen Rule

## ⚠️ CRITICAL: One Cubit Per Screen

**Each screen/page MUST have only ONE cubit. Never use `MultiBlocProvider` with multiple cubits on the same screen.**

## Rule

Every screen/page should use a single `BlocProvider` with one cubit that handles all the screen's state management needs.

## ✅ Correct Pattern

### Single Cubit for Screen

```dart
@RoutePage()
class ViewCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ViewCategoriesCubit>()..getCategories(),
      child: Scaffold(
        // ... screen content
      ),
    );
  }
}
```

### Combined Functionality in One Cubit

```dart
@injectable
class ViewCategoriesCubit extends BaseCubit<ViewCategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  ViewCategoriesCubit(
    this.getCategoriesUseCase,
    this.deleteCategoryUseCase,
  ) : super(ViewCategoriesInitial());

  Future<void> getCategories() async {
    emit(ViewCategoriesLoading());
    // ... implementation
  }

  Future<void> deleteCategory(int id) async {
    emit(ViewCategoriesDeleting(categories, id));
    // ... implementation
  }
}
```

## ❌ Incorrect Pattern

### Multiple Cubits on Same Screen

```dart
// ❌ BAD - Using MultiBlocProvider
@RoutePage()
class ViewCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<GetCategoriesCubit>()),
        BlocProvider(create: (context) => getIt<DeleteCategoryCubit>()),
      ],
      child: Scaffold(
        // ... screen content
      ),
    );
  }
}
```

## When to Combine Functionality

If a screen needs multiple operations (e.g., get, create, update, delete), combine them into a single cubit:

- **ViewCategoriesPage** → `ViewCategoriesCubit` (handles get + delete)
- **AddCategoryPage** → `CategoryFormCubit` (handles create + update)
- **LoginPage** → `LoginCubit` (handles login only)
- **SettingsPage** → `SettingsCubit` (handles all settings operations)

## Benefits

1. **Simpler State Management**: One source of truth for screen state
2. **Easier Testing**: Test one cubit instead of multiple
3. **Better Maintainability**: All related logic in one place
4. **Cleaner Code**: No need for `MultiBlocProvider` or `MultiBlocListener`
5. **Better Performance**: Fewer providers to manage

## Migration Pattern

When refactoring from multiple cubits to one:

1. **Create combined cubit** that includes all use cases
2. **Create combined state** that handles all operations
3. **Update screen** to use single `BlocProvider`
4. **Update listeners/builders** to handle all states
5. **Delete old cubits** after migration

## Example: Combining Get + Delete

### Before (Multiple Cubits)
```dart
// GetCategoriesCubit - handles fetching
// DeleteCategoryCubit - handles deletion
MultiBlocProvider with both cubits
```

### After (Single Cubit)
```dart
// ViewCategoriesCubit - handles both fetching and deletion
BlocProvider with ViewCategoriesCubit
```

## State Design

When combining functionality, design states to handle all operations:

```dart
abstract class ViewCategoriesState extends Equatable {}

class ViewCategoriesInitial extends ViewCategoriesState {}
class ViewCategoriesLoading extends ViewCategoriesState {}
class ViewCategoriesSuccess extends ViewCategoriesState {
  final List<Category> categories;
}
class ViewCategoriesError extends ViewCategoriesState {
  final String message;
}
class ViewCategoriesDeleting extends ViewCategoriesState {
  final List<Category> categories;
  final int deletingId;
}
class ViewCategoriesDeleteSuccess extends ViewCategoriesState {
  final List<Category> categories;
  final int deletedId;
}
class ViewCategoriesDeleteError extends ViewCategoriesState {
  final List<Category> categories;
  final String message;
}
```

## Quick Checklist

Before creating a new screen or adding functionality:
- [ ] Does the screen already have a cubit?
- [ ] Can the new functionality be added to the existing cubit?
- [ ] Is `MultiBlocProvider` being used? (Should be avoided)
- [ ] Are all related operations in the same cubit?

## Exception

**No exceptions.** Every screen must have exactly one cubit. If functionality seems unrelated, reconsider the screen's scope or create a separate screen.

---

**Remember: One screen = One cubit. Combine related functionality, don't split it across multiple cubits!**
