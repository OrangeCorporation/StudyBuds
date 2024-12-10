// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// import 'package:study_buds/main.dart';

// class AuthUtils {
//   static final _storage = FlutterSecureStorage();

//   static Future<void> authenticateWithUnige(BuildContext context) async {
//     try {
//       final result = await FlutterWebAuth2.authenticate(
//           url: "$API_URL/login", //Backend Login URL
//           callbackUrlScheme: "myapp");

//       final Uri uri = Uri.parse(result);
//       final token = uri.queryParameters['token'];
//       if (token != null) {
//         await _storage.write(key: 'session_token', value: token);
//         //token is saved, Push the home page, (Go to home page)
//         Navigator.pushReplacementNamed(context, '/profile');
//       } else {
//         //show error
//         _showError(context, 'Authentication Failed: Token not received');
//       }
//     } catch (e) {
//       //show error
//       _showError(context, 'Authentication Failed: $e');
//     }
//   }

//   static Future<void> logout(BuildContext context) async {
//     await _storage.delete(key: 'session_token');
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   static void _showError(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:study_buds/utils/static_env.dart';

class AuthUtils {
  static final _storage = FlutterSecureStorage();

  static Future<void> authenticateWithUnige(BuildContext context) async {
  final String loginUrl = "$API_URL/login";
  // "http://34.154.87.170:5000/login";
  final String callbackUrlScheme = "myapp";

  // Navigate to the login screen with a WebView
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebViewLoginScreen(
        url: loginUrl,
        callbackUrlScheme: callbackUrlScheme,
      ),
    ),
  );

  if (result != null && result is String) {
    final Uri uri = Uri.parse(result);
    final token = uri.queryParameters['token'];

    if (token != null) {
      await _storage.write(key: 'session_token', value: token);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showError(context, 'Authentication Failed: Token not received');
    }
  } else {
    _showError(context, 'Authentication Canceled or Failed');
  }
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

class WebViewLoginScreen extends StatefulWidget {
  final String url;
  final String callbackUrlScheme;

  const WebViewLoginScreen({
    Key? key,
    required this.url,
    required this.callbackUrlScheme,
  }) : super(key: key);

  @override
  State<WebViewLoginScreen> createState() => _WebViewLoginScreenState();
}

class _WebViewLoginScreenState extends State<WebViewLoginScreen> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onLoadStart: (controller, url) {
          if (url != null && url.scheme == widget.callbackUrlScheme) {
            print("Loaded URL: $url");
            final token = Uri.parse(url.toString()).queryParameters['token'];
            if (token != null) {
              // Navigator.pushReplacementNamed(context, '/home');
              Navigator.pop(context, url.toString());
            } else {
              _showError(context, 'Authentication Failed: Token not received');
              Navigator.pop(context, null);
            }
          }
        },
      ),
    );
  }

  void _showError(BuildContext context, String message) {
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
