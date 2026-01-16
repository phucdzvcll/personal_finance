/// Input validation utilities
class InputValidator {
  /// Validates email format
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Validates password strength
  static bool isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
    ).hasMatch(password);
  }

  /// Validates phone number
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[\d\s-()]{10,}$').hasMatch(phone);
  }

  /// Validates username or email
  /// Accepts either a username (alphanumeric, underscore, dot, hyphen) or email format
  static bool isValidUsernameOrEmail(String input) {
    // Username: 3-30 characters, alphanumeric, underscore, dot, hyphen
    final usernamePattern = RegExp(r'^[a-zA-Z0-9._-]{3,30}$');
    // Email pattern
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return usernamePattern.hasMatch(input) || emailPattern.hasMatch(input);
  }
}
