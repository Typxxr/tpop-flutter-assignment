import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'config/app_env.dart';
import 'firebase/firebase_options_staging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('th');
  await initializeDateFormatting('en');
  await initializeDateFormatting('th_TH');
  await initializeDateFormatting('en_US');

  const env = AppEnv(
    flavor: AppFlavor.staging,
    appName: 'Pack Mate Staging',
    baseUrl: 'https://staging-api.....com',
    stagingUserId: 'uid_12345',
  );

  Get.put<AppEnv>(env, permanent: true);

  runApp(const MyApp(env: env));
}