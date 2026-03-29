import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'app_error.dart';

class ErrorMapper {
  static AppError map(dynamic error) {
    final langCode = Get.locale?.languageCode ?? 'th';

    if (error is FirebaseException) {
      return _mapFirebaseException(error, langCode);
    }

    if (error is SocketException) {
      return AppError(
        type: AppErrorType.network,
        message: _text(
          langCode,
          th: 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบเครือข่ายแล้วลองใหม่',
          en: 'No internet connection. Please check your network and try again.',
        ),
        debugMessage: error.toString(),
      );
    }

    if (error is TimeoutException) {
      return AppError(
        type: AppErrorType.timeout,
        message: _text(
          langCode,
          th: 'การเชื่อมต่อใช้เวลานานเกินไป กรุณาลองใหม่อีกครั้ง',
          en: 'The request timed out. Please try again.',
        ),
        debugMessage: error.toString(),
      );
    }

    return AppError(
      type: AppErrorType.unknown,
      message: _text(
        langCode,
        th: 'เกิดข้อผิดพลาดบางอย่าง กรุณาลองใหม่อีกครั้ง',
        en: 'Something went wrong. Please try again again.',
      ),
      debugMessage: error.toString(),
    );
  }

  static AppError _mapFirebaseException(
    FirebaseException error,
    String langCode,
  ) {
    switch (error.code) {
      case 'permission-denied':
        return AppError(
          type: AppErrorType.permission,
          message: _text(
            langCode,
            th: 'คุณไม่มีสิทธิ์เข้าถึงข้อมูลนี้',
            en: 'You do not have permission to access this data.',
          ),
          debugMessage: error.message ?? error.toString(),
        );

      case 'unavailable':
        return AppError(
          type: AppErrorType.network,
          message: _text(
            langCode,
            th: 'ไม่สามารถเชื่อมต่อบริการได้ในขณะนี้ กรุณาลองใหม่',
            en: 'The service is currently unavailable. Please try again.',
          ),
          debugMessage: error.message ?? error.toString(),
        );

      case 'deadline-exceeded':
        return AppError(
          type: AppErrorType.timeout,
          message: _text(
            langCode,
            th: 'คำขอใช้เวลานานเกินไป กรุณาลองใหม่',
            en: 'The request took too long. Please try again.',
          ),
          debugMessage: error.message ?? error.toString(),
        );

      case 'not-found':
        return AppError(
          type: AppErrorType.notFound,
          message: _text(
            langCode,
            th: 'ไม่พบข้อมูลที่ต้องการ',
            en: 'The requested data was not found.',
          ),
          debugMessage: error.message ?? error.toString(),
        );

      case 'unauthenticated':
        return AppError(
          type: AppErrorType.unauthorized,
          message: _text(
            langCode,
            th: 'กรุณาเข้าสู่ระบบก่อนใช้งาน',
            en: 'Please sign in before continuing.',
          ),
          debugMessage: error.message ?? error.toString(),
        );

      case 'aborted':
      case 'cancelled':
        return AppError(
          type: AppErrorType.unknown,
          message: _text(
            langCode,
            th: 'รายการถูกยกเลิก',
            en: 'The operation was cancelled.',
          ),
          debugMessage: error.message ?? error.toString(),
        );

      default:
        return AppError(
          type: AppErrorType.server,
          message: _text(
            langCode,
            th: 'ระบบขัดข้องชั่วคราว กรุณาลองใหม่อีกครั้ง',
            en: 'A server error occurred. Please try again.',
          ),
          debugMessage: error.message ?? error.toString(),
        );
    }
  }

  static String _text(
    String langCode, {
    required String th,
    required String en,
  }) {
    return langCode == 'th' ? th : en;
  }

}


