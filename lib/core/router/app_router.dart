import 'package:auto_route/auto_route.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/transactions/transactions_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/main_tab/main_tab_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          initial: true,
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
      ];
}
