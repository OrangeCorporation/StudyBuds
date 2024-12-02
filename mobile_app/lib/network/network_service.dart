import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'
    as http; // it abstracts the low level details to make http requests

enum HttpVerb { GET, POST }

class NetworkService {
  static final NetworkService instance = NetworkService._internal();
  final String _baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://127.0.0.1:5000');

  NetworkService._internal();

  // send the http request and returns the http response
  Future<http.Response> sendHTTPRequest(
      String endPoint, HttpVerb httpVerb, Map<String, dynamic> parameters) {
    final Uri url = Uri.parse("$_baseUrl$endPoint");

    if (httpVerb == HttpVerb.GET) {
      return http.get(url);
    } else if (httpVerb == HttpVerb.POST) {
      return http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(parameters));
    } else {
      throw Exception("Unsupported HTTP verb");
    }
  }
}
