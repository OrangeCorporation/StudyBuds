import 'package:http/http.dart' as http;

enum HttpVerb { get, post }

class NetworkService {
  static final NetworkService instance = NetworkService._internal();
  final String _baseUrl = API_URL;

  NetworkService._internal();

  // send the http request and returns the http response
  Future<http.Response> sendHTTPRequest(
      String endPoint, HttpVerb httpVerb, Map<String, dynamic> parameters) {
    final Uri url = Uri.parse("$_baseUrl$endPoint");

    if (httpVerb == HttpVerb.get) {
      return http.get(url);
    } else if (httpVerb == HttpVerb.post) {
      return http.post(url,
          headers: {"Content-Type": "application/json"}, body: parameters);
    } else {
      throw Exception("Unsupported HTTP verb");
    }
  }
}
