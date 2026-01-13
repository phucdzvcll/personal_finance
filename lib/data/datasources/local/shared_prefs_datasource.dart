import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

@lazySingleton
class SharedPrefsDataSource {
  final SharedPreferences _prefs;

  SharedPrefsDataSource(this._prefs);

  // Token management
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }

  Future<bool> removeToken() async {
    return await _prefs.remove(AppConstants.tokenKey);
  }

  // Refresh token management
  Future<bool> saveRefreshToken(String refreshToken) async {
    return await _prefs.setString(AppConstants.refreshTokenKey, refreshToken);
  }

  String? getRefreshToken() {
    return _prefs.getString(AppConstants.refreshTokenKey);
  }

  Future<bool> removeRefreshToken() async {
    return await _prefs.remove(AppConstants.refreshTokenKey);
  }

  // User ID management
  Future<bool> saveUserId(int userId) async {
    return await _prefs.setInt(AppConstants.userIdKey, userId);
  }

  int? getUserId() {
    return _prefs.getInt(AppConstants.userIdKey);
  }

  Future<bool> removeUserId() async {
    return await _prefs.remove(AppConstants.userIdKey);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
