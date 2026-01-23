import 'package:injectable/injectable.dart';
import '../../data/datasources/local/shared_prefs_datasource.dart';
import '../router/app_router.dart';

/// Global router instance (set from App widget)
AppRouter? _globalRouter;

/// Service to handle authentication-related operations like logout
@lazySingleton
class AuthService {
  final SharedPrefsDataSource _sharedPrefsDataSource;

  AuthService(this._sharedPrefsDataSource);

  /// Set the global router instance (should be called from App widget)
  static void setGlobalRouter(AppRouter router) {
    _globalRouter = router;
  }

  /// Clear all authentication data and navigate to login
  Future<void> forceLogout() async {
    // Clear all tokens and user data
    await _sharedPrefsDataSource.removeToken();
    await _sharedPrefsDataSource.removeRefreshToken();
    await _sharedPrefsDataSource.removeUserId();

    // Navigate to login screen, clearing all routes
    if (_globalRouter != null) {
      _globalRouter!.replaceAll([const LoginRoute()]);
    }
  }
}
