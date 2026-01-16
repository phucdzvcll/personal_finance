import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/local/shared_prefs_datasource.dart';
import '../../../di/injection.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait a bit for splash screen visibility
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final sharedPrefsDataSource = getIt<SharedPrefsDataSource>();
    final token = sharedPrefsDataSource.getToken();

    if (token != null && token.isNotEmpty) {
      // User is logged in, navigate to main tab page
      if (mounted) {
        context.router.replaceAll([const MainTabRoute()]);
      }
    } else {
      // No token, navigate to login page
      if (mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
