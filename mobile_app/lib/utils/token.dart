import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'session_token';

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
}