import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_buds/firebase_options.dart';
import 'package:study_buds/screens/login/login.dart';
import 'package:study_buds/screens/basic_search/basic_search.dart';
import 'package:study_buds/utils/push_notification.dart';

void main() async {
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PushNotificationService.instance.retrievePushNotificationToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      //home: const Login(title: "Login"),
      home: BasicSearchPage(title: "kk"),
    );
  }
}
