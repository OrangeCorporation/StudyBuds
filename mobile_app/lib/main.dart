import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_buds/firebase_options.dart';
import 'package:study_buds/models/response_body.dart';
import 'package:study_buds/screens/login/login.dart';
import 'package:study_buds/screens/main.dart';
import 'package:study_buds/utils/auth_utils.dart';
import 'package:study_buds/utils/push_notification.dart';
import 'package:study_buds/utils/static_env.dart';

import 'telegram/telegram_bot.dart';

void main() async {
  if (DRIVER) enableFlutterDriverExtension(); // Keep DRIVER testing logic
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Push Notifications
  PushNotificationService.instance.retrievePushNotificationToken();

  await Hive.initFlutter();

  // Register the ResponseBody Adapter
  Hive.registerAdapter(ResponseBodyAdapter());
  
  //Start Telegram Bot
  TelegramBot.getTelegramId();

  // Check if the user is authenticated
  final isAuthenticated = await AuthUtils.isAuthenticated();

  fetchAndCacheExample();
  runApp(MyApp(isAuthenticated: isAuthenticated));
}

Future<void> saveResponseBody(ResponseBody responseBody) async {
  var box = await Hive.openBox<ResponseBody>('responseBox');
  await box.put('response_body', responseBody);
  await box.close(); // Always close the box when done
}

Future<ResponseBody?> getResponseBody() async {
  var box = await Hive.openBox<ResponseBody>('responseBox');
  final response = box.get('response_body');
  await box.close(); // Always close the box when done
  return response;
}


void fetchAndCacheExample() async {
  // Example ResponseBody
  var responseBody = ResponseBody(id: '123', data: 'Sample data');

  // Save the response
  await saveResponseBody(responseBody);

  // Retrieve and print the cached response
  var cachedResponse = await getResponseBody();
  if (cachedResponse != null) {
    print('Cached Response: ${cachedResponse.data}');
  } else {
    print('No cached response found');
  }
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({Key? key, required this.isAuthenticated}) : super(key: key);

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
      // Dynamically set the initial route based on authentication state
      initialRoute: isAuthenticated ? '/home' : '/login',
      routes: {
        '/home': (context) => const MainScreen(),
        '/login': (context) =>
            const Login(key: Key("login_page"), title: "Login"),
      },
    );
  }
}
