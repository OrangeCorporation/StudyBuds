import 'dart:convert';

import 'package:http/http.dart'
    as http;
import 'package:study_buds/utils/static_env.dart';
import 'package:study_buds/utils/token.dart'; // it abstracts the low level details to make http requests

enum HttpVerb { GET, POST }
class NetworkService {
  static final NetworkService instance = NetworkService._internal();

  NetworkService._internal();

  // send the http request and returns the http response
  Future<http.Response> sendHTTPRequest(
      String endPoint, HttpVerb httpVerb, Map<String, dynamic> parameters) async{
    final token = await TokenStorage.getToken();
    print(token);
    final headers = {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final Uri url = Uri.parse("$API_URL$endPoint");
    print(url);
    if (httpVerb == HttpVerb.GET) {
      return http.get(url, headers: headers);
    } else if (httpVerb == HttpVerb.POST) {
      return http.post(url,
          headers: headers,
          body: jsonEncode(parameters));
    } else {
      throw Exception("Unsupported HTTP verb");
    }
  }
}
