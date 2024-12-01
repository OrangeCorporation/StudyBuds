import 'dart:convert';
import 'package:http/http.dart';

//  parse raw HTTP responses into structured BaseHttpResponse objects.
class BaseHttpResponseBuilder<T> {
  final T Function(Map<String, dynamic> jsonObject)? _dataFactory;

  BaseHttpResponseBuilder({T Function(Map<String, dynamic>)? dataFactory})
      : _dataFactory = dataFactory;

  BaseHttpResponse<T> generateResponse(Response? response,
      {required Map<String, dynamic> requestParams}) {
    if (response == null) {
      print("No response received.");
      return BaseHttpResponse<T>(
        requestFailed: true,
        requestParams: requestParams,
      );
    }

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    try {
      final parsedJson = jsonDecode(response.body);
      return BaseHttpResponse<T>(
        requestFailed: false,
        requestParams: requestParams,
        statusCode: response.statusCode,
        data: _dataFactory != null ? _dataFactory!(parsedJson) : null,
      );
    } catch (e) {
      print("Error decoding JSON: $e");
      return BaseHttpResponse<T>(
        requestFailed: true,
        requestParams: requestParams,
        statusCode: response.statusCode,
      );
    }
  }
}

class BaseHttpResponse<T> {
  bool requestFailed;
  Map<String, dynamic> requestParams;
  int? statusCode;
  T? data;

  BaseHttpResponse({
    required this.requestFailed,
    required this.requestParams,
    this.statusCode,
    this.data,
  });
}
