/// Sealed hierarchy of all errors the app can surface.
/// Every layer catches raw exceptions and maps them to one of these.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// No connectivity or request timed out.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

/// The server responded with a non-2xx status code.
class ServerException extends AppException {
  const ServerException({
    String message = 'The server encountered an error. Please try again.',
    this.statusCode,
  }) : super(message);

  final int? statusCode;
}

/// 404 — the requested resource does not exist.
class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'The requested resource could not be found.',
  ]);
}

/// JSON parsing failed or a required field was null/wrong type.
class ParseException extends AppException {
  const ParseException([
    super.message = 'Received unexpected data from the server.',
  ]);
}

/// Catch-all for anything not covered above.
class UnknownException extends AppException {
  const UnknownException([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}
