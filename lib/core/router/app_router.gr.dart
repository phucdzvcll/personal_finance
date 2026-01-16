// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  @override
  final Map<String, PageFactory> pagesMap = {
    AddCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<AddCategoryRouteArgs>(
          orElse: () => const AddCategoryRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AddCategoryPage(
          key: args.key,
          category: args.category,
        ),
      );
    },
    AddTransactionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddTransactionPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainTabPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    TransactionsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TransactionsPage(),
      );
    },
    ViewCategoriesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ViewCategoriesPage(),
      );
    },
  };
}

/// generated route for
/// [AddCategoryPage]
class AddCategoryRoute extends PageRouteInfo<AddCategoryRouteArgs> {
  AddCategoryRoute({
    Key? key,
    Category? category,
    List<PageRouteInfo>? children,
  }) : super(
          AddCategoryRoute.name,
          args: AddCategoryRouteArgs(
            key: key,
            category: category,
          ),
          initialChildren: children,
        );

  static const String name = 'AddCategoryRoute';

  static const PageInfo<AddCategoryRouteArgs> page =
      PageInfo<AddCategoryRouteArgs>(name);
}

class AddCategoryRouteArgs {
  const AddCategoryRouteArgs({
    this.key,
    this.category,
  });

  final Key? key;

  final Category? category;

  @override
  String toString() {
    return 'AddCategoryRouteArgs{key: $key, category: $category}';
  }
}

/// generated route for
/// [AddTransactionPage]
class AddTransactionRoute extends PageRouteInfo<void> {
  const AddTransactionRoute({List<PageRouteInfo>? children})
      : super(
          AddTransactionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddTransactionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainTabPage]
class MainTabRoute extends PageRouteInfo<void> {
  const MainTabRoute({List<PageRouteInfo>? children})
      : super(
          MainTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TransactionsPage]
class TransactionsRoute extends PageRouteInfo<void> {
  const TransactionsRoute({List<PageRouteInfo>? children})
      : super(
          TransactionsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ViewCategoriesPage]
class ViewCategoriesRoute extends PageRouteInfo<void> {
  const ViewCategoriesRoute({List<PageRouteInfo>? children})
      : super(
          ViewCategoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ViewCategoriesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
