import 'dart:io';

import 'package:http/http.dart' as http;

enum HttpVerb { GET, POST }

class NetworkService {
  static final NetworkService instance = NetworkService._internal();
  final String _baseUrl = "${Platform.environment['API_URL']}";

  NetworkService._internal();

  // send the http request and returns the http response
  Future<http.Response> sendHTTPRequest(
      String endPoint, HttpVerb httpVerb, Map<String, dynamic> parameters) {
    final Uri url = Uri.parse("$_baseUrl$endPoint");

    print("Http verb:");
    print(httpVerb);
    print("Base url:");
    print(_baseUrl);
    print("Url:");
    print(url);

    if (httpVerb == HttpVerb.GET) {
      return http.get(url);
    } else if (httpVerb == HttpVerb.POST) {
      return http.post(url,
          headers: {"Content-Type": "application/json"}, body: parameters);
    } else {
      throw Exception("Unsupported HTTP verb");
    }
  }
}
