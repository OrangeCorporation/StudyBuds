import 'dart:convert';
import 'package:http/http.dart';

class BaseHttpResponseBuilder<T> {
  final T Function(Map<String, dynamic> jsonObject)? _dataFactory;

  BaseHttpResponseBuilder({T Function(Map<String, dynamic>)? dataFactory})
      : _dataFactory = dataFactory;

  BaseHttpResponse<T> generateResponse(Response? response,
      {required Map<String, dynamic> requestParams}) {
    bool requestFailed = response == null;
    return BaseHttpResponse<T>(
      requestFailed: requestFailed,
      requestParams: requestParams,
      statusCode: requestFailed ? null : response.statusCode,
      data: requestFailed || _dataFactory == null
          ? null
          : _dataFactory!(jsonDecode(response.body)),
    );
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
