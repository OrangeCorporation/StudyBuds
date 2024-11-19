import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class AuthUtils {
  static final _storage = FlutterSecureStorage();

  static Future<void> authenticateWithUnige(BuildContext context) async {
    try {
      final result = await FlutterWebAuth2.authenticate(
          url: "https://127.0.0.1:8080/simplesaml", //Backend Login URL
          callbackUrlScheme: "myapp");

      final Uri uri = Uri.parse(result);
      final token = uri.queryParameters['token'];

      if (token != null) {
        await _storage.write(key: 'session_token', value: token);
        //TODO Push the home page
        //token is saved, Push the home page, (Go to home page)
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
    //TODO push back to the login page
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
