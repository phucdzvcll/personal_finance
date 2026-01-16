import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/domain/entities/category.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/transactions/transactions_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/main_tab/main_tab_page.dart';
import '../../presentation/pages/category/add_category_page.dart';
import '../../presentation/pages/category/view_categories_page.dart';
import '../../presentation/pages/splash/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: LoginRoute.page,
        ),
        AutoRoute(
          page: RegisterRoute.page,
        ),
        AutoRoute(
          page: MainTabRoute.page,
          children: [
            AutoRoute(
              page: HomeRoute.page,
            ),
            AutoRoute(
              page: TransactionsRoute.page,
            ),
            AutoRoute(
              page: SettingsRoute.page,
            ),
          ],
        ),
        AutoRoute(
          page: AddCategoryRoute.page,
        ),
        AutoRoute(
          page: ViewCategoriesRoute.page,
        ),
      ];
}
