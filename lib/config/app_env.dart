import 'package:firebase_auth/firebase_auth.dart';

enum AppFlavor {
  staging,
  prod,
}

class AppEnv {
  final AppFlavor flavor;
  final String appName;
  final String baseUrl;
  final String? stagingUserId;

  const AppEnv({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    this.stagingUserId,
  });

  bool get isStaging => flavor == AppFlavor.staging;
  bool get isProd => flavor == AppFlavor.prod;

  String? get currentUserIdOrNull {
    if (isStaging) {
      return stagingUserId;
    }

    return FirebaseAuth.instance.currentUser?.uid;
  }
}