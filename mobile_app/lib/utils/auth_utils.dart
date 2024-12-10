import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:study_buds/main.dart';

class AuthUtils {
  static final _storage = FlutterSecureStorage();

  static Future<void> authenticateWithUnige(BuildContext context) async {
    try {
      final result = await FlutterWebAuth2.authenticate(
          url: "$API_URL/login", //Backend Login URL
          callbackUrlScheme: "myapp",
          options: FlutterWebAuth2Options(useWebview: false));

      final Uri uri = Uri.parse(result);
      final token = uri.queryParameters['token'];

      if (token != null) {
        await _storage.write(key: 'session_token', value: token);
        //token is saved, Push the home page, (Go to home page)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        //show error
        _showError(context, 'Authentication Failed: Token not received');
      }
    } catch (e) {
      //show error
      _showError(context, 'Authentication Failed: $e');
    }
  }

  static Future<void> logout(BuildContext context) async {
    await _storage.delete(key: 'session_token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  static void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
