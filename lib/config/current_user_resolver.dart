import 'package:firebase_auth/firebase_auth.dart';
import 'package:pack_mate/config/app_env.dart';

class CurrentUserResolver {
  final AppEnv env;

  const CurrentUserResolver(this.env);

  String get userId {
    if (env.isStaging) {
      final id = env.stagingUserId;
      if (id == null || id.isEmpty) {
        throw Exception('stagingUserId is not configured for staging environment');
      }
      return id;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No logged-in user found');
    }

    return user.uid;
  }
}