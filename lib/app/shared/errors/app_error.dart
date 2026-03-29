enum AppErrorType {
  network,
  timeout,
  permission,
  notFound,
  server,
  unauthorized,
  forbidden,
  validation,
  unknown,
}

class AppError {
  final AppErrorType type;
  final String message;
  final String? debugMessage;

  const AppError({
    required this.type,
    required this.message,
    this.debugMessage,
  });
}