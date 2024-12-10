import 'dart:convert';

import 'package:http/http.dart'
    as http;
import 'package:study_buds/utils/token.dart'; // it abstracts the low level details to make http requests

enum HttpVerb { GET, POST }

class NetworkService {
  static final NetworkService instance = NetworkService._internal();
  final String _baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:5000');

  NetworkService._internal();

  // send the http request and returns the http response
  Future<http.Response> sendHTTPRequest(
      String endPoint, HttpVerb httpVerb, Map<String, dynamic> parameters) async {
    final token = await TokenStorage.getToken(); // Fetch the token from storage

    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final Uri url = Uri.parse("$_baseUrl$endPoint");

    
    if (httpVerb == HttpVerb.GET) {
      return http.get(url, headers: headers);
    } else if (httpVerb == HttpVerb.POST) {
      return http.post(url,
          headers: headers, body: jsonEncode(parameters));
    } else {
      throw Exception("Unsupported HTTP verb");
    }
  }
}