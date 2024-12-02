import 'dart:convert';
import 'package:http/http.dart';

/// Parses raw HTTP responses into structured BaseHttpResponse objects.
class BaseHttpResponseBuilder<T> {
  final T Function(dynamic jsonObject)? _dataFactory;

  BaseHttpResponseBuilder({T Function(dynamic)? dataFactory})
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
      // Parse the response into a dynamic JSON structure (can be Map or List)
      print("vvvvv");
      final parsedJson = jsonDecode(response.body);
      print(parsedJson);
      print("vvvvv");
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

/// Represents a structured HTTP response.
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
