abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkNotFoundException extends AppException {
  const NetworkNotFoundException() : super('No internet connection available.');
}

class ServerException extends AppException {
  const ServerException(): super("Server error occurred.");
}
