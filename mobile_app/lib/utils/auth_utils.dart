import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:study_buds/utils/static_env.dart';
import 'package:http/http.dart' as http;

class AuthUtils {
  static final _storage = FlutterSecureStorage();

  static Future<void> authenticateWithUnige(BuildContext context) async {
    try {
      final result = await FlutterWebAuth2.authenticate(
          url: "$API_URL/login", // Backend Login URL
          callbackUrlScheme: "myapp",
          options: FlutterWebAuth2Options(useWebview: false));

      final Uri uri = Uri.parse(result);
      final token = uri.queryParameters['token'];

      if (token != null) {
        await _storage.write(key: 'session_token', value: token);
        // Token is saved, Push the home page, (Go to home page)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error
        _showError(context, 'Authentication Failed: Token not received');
      }
    } catch (e) {
      // Show error
      _showError(context, 'Authentication Failed: $e');
    }
  }

  static Future<void> logout(BuildContext context) async {
    // Retrieve the current session token
    // final token = await _storage.read(key: 'session_token');
    //
    // // Make a logout request to the backend if the token exists
    // if (token != null) {
    //   try {
    //     await http.post(
    //       Uri.parse('$API_URL/logout'), // Replace with your backend logout endpoint
    //       headers: {'Authorization': 'Bearer $token'},
    //     );
    //   } catch (e) {
    //     debugPrint('Failed to log out from the server: $e');
    //   }
    // }
    // Clear the local session
    await _storage.delete(key: 'session_token');
    // Navigate to the login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Persistence Login Logic
  static Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'session_token');
    return token != null && token.isNotEmpty;
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
