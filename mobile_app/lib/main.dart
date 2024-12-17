import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:study_buds/firebase_options.dart';
import 'package:study_buds/screens/login/login.dart';
import 'package:study_buds/screens/main.dart';
import 'package:study_buds/utils/push_notification.dart';

const API_URL =
    String.fromEnvironment("API_URL", defaultValue: "http://10.0.2.2:5000");

const DRIVER_ENABLED =
    bool.fromEnvironment("DRIVER_ENABLED", defaultValue: false);

void main() async {
  if (DRIVER_ENABLED)
    enableFlutterDriverExtension(); // Comment out or remove this line
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PushNotificationService.instance.retrievePushNotificationToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyBuds',
      theme: ThemeData(
        primaryColor: const Color(0xFF252B33),
        primaryColorDark: const Color(0XFF000814),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF252B33),
          primaryContainer: const Color(0XFF000814),
          secondary: const Color(0XFFFF6600),
          secondaryContainer: const Color(0XFFF06000),
        ),
        fontFamily: 'Quicksand',
        useMaterial3: false,
      ),
      home: const Login(key: Key("login_page"), title: "Login"),
      routes: {
        '/home': (context) => const MainScreen(),
        '/login': (context) =>
            const Login(key: Key("login_page"), title: "Login"),
      },
    );
  }
}
