import 'package:flutter/material.dart';
import 'app_error.dart';

class ErrorIconMapper {
  static IconData iconFor(AppErrorType type) {
    switch (type) {
      case AppErrorType.network:
        return Icons.wifi_off_rounded;
      case AppErrorType.timeout:
        return Icons.access_time_rounded;
      case AppErrorType.permission:
      case AppErrorType.forbidden:
        return Icons.lock_outline_rounded;
      case AppErrorType.notFound:
        return Icons.search_off_rounded;
      case AppErrorType.unauthorized:
        return Icons.person_off_outlined;
      case AppErrorType.server:
        return Icons.dns_outlined;
      case AppErrorType.validation:
        return Icons.info_outline_rounded;
      case AppErrorType.unknown:
        return Icons.error_outline;
    }
  }
}