import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/app_router.dart';
import '../../cubit/home/home_cubit.dart';
import '../../../di/injection.dart';

@RoutePage()
class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _previousTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        HomeRoute(),
        TransactionsRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        // Refresh home summary when switching back to home tab
        if (tabsRouter.activeIndex == 0 && _previousTabIndex != 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Try to refresh home summary if home cubit is available
            try {
              final homeCubit = getIt<HomeCubit>();
              final now = DateTime.now();
              homeCubit.getMonthlySummary(now.year, now.month);
            } catch (e) {
              // Cubit might not be initialized yet, ignore
            }
          });
        }
        _previousTabIndex = tabsRouter.activeIndex;

        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
