# View Categories Feature

## Overview

This document describes the implementation of the "View Categories" feature that allows users to see all their categories in a list view.

## Architecture

The feature follows Clean Architecture principles with three main layers:

### Domain Layer
- **Entity**: `Category` (already exists)
- **Repository Interface**: `CategoryRepository.getCategories()` (already exists)
- **Use Case**: `GetCategoriesUseCase` - Fetches all categories

### Data Layer
- **Model**: `CategoryModel` (already exists)
- **Remote Data Source**: `CategoryRemoteDataSource.getCategories()` (already exists)
- **Repository Implementation**: `CategoryRepositoryImpl.getCategories()` (already exists)

### Presentation Layer
- **Cubit**: `GetCategoriesCubit` - Manages state for fetching categories
- **States**: 
  - `GetCategoriesInitial` - Initial state
  - `GetCategoriesLoading` - Loading state
  - `GetCategoriesSuccess` - Success with list of categories
  - `GetCategoriesError` - Error with message
- **Page**: `ViewCategoriesPage` - UI to display categories

## Files Created

1. **Domain Layer**:
   - `lib/domain/usecases/get_categories_usecase.dart`

2. **Presentation Layer**:
   - `lib/presentation/cubit/category/get_categories_cubit.dart`
   - `lib/presentation/cubit/category/get_categories_state.dart`
   - `lib/presentation/pages/category/view_categories_page.dart`

3. **Router**:
   - Updated `lib/core/router/app_router.dart` to include `ViewCategoriesRoute`

4. **Translations**:
   - Added translations to all language files:
     - `viewCategories` - Page title
     - `noCategoriesFound` - Empty state message
     - `retry` - Retry button text

## API Response Format

The API returns an array of categories:

```json
[
  {
    "id": 1,
    "name": "Food",
    "type": "expense",
    "icon": "food",
    "color": "#FF5733",
    "createdAt": "2026-01-13T03:55:49.487Z",
    "updatedAt": "2026-01-13T03:55:49.487Z"
  }
]
```

## Features

1. **List View**: Displays all categories in a card-based list
2. **Icon Display**: Shows the category icon with the selected color
3. **Category Type**: Displays whether the category is "Expense" or "Income"
4. **Pull to Refresh**: Users can pull down to refresh the list
5. **Error Handling**: Shows error message with retry button
6. **Empty State**: Shows a message when no categories are found
7. **Loading State**: Shows loading indicator while fetching

## Navigation

The feature can be accessed from:
- **Settings Page** → Category Management → View Categories

## Usage

```dart
// Navigate to view categories
context.router.push(const ViewCategoriesRoute());
```

## Icon Resolution

The page resolves icon names from the `icons.dart` constants file. If an icon name matches, it displays the corresponding FontAwesome icon. If not found, it falls back to a default category icon.

## Color Display

Each category displays its icon with the selected color:
- Icon color matches the category's color
- Container background uses the color with 10% opacity
- Border uses the full color

## Translation Keys

All user-facing strings use translations:
- `context.l10n.viewCategories` - Page title
- `context.l10n.noCategoriesFound` - Empty state
- `context.l10n.retry` - Retry button
- `context.l10n.expense` - Expense type
- `context.l10n.income` - Income type

## Future Enhancements

- Add category details page
- Add edit category functionality
- Add delete category functionality
- Add filter by type (expense/income)
- Add search functionality
- Add category statistics
