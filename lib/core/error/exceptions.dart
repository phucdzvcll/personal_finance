/// Base class for all exceptions
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

/// Server exception
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Cache exception
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException(super.message);
}
