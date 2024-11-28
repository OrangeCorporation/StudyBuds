import 'package:http/http.dart';
import '../network/base_http_response.dart';
import '../network/network_service.dart';

/*

The files in this folder defines an abstract and reusable framework for handling http requests and 
responses in dart

Purpose of the Framework
This setup provides:
Flexibility: The generic types and builder pattern allow you to reuse the same logic for any API and data type.
Error Handling: Centralized mechanisms for managing failed requests.
Separation of Concerns:
NetworkService handles low-level HTTP details.
BaseHttpRequest abstracts request logic.
BaseHttpResponseBuilder parses responses into usable objects.
This is a good starting point for scalable and maintainable API integration.
*/

// defines a generic http request
// <B extends BaseHttpResponseBuilder<T>, T> allows the class to handle any type of response builder (B) and response data type (T)
abstract class BaseHttpRequest<B extends BaseHttpResponseBuilder<T>, T> {
  HttpVerb _httpVerb; // http method (get, post, ..)
  String _endPoint; // api endpoint for the request
  Map<String, dynamic>
      _parameters; // query params or request body sent with the request
  B _responseBuilder; // a builder to parse and handle the response
  bool _responseArrived =
      false; // a tracker that tells if the response has been received

  BaseHttpRequest({
    required HttpVerb httpVerb,
    required String endPoint,
    required B responseBuilder,
    Map<String, dynamic> parameters = const {},
  })  : _httpVerb = httpVerb,
        _endPoint = endPoint,
        _parameters = parameters,
        _responseBuilder = responseBuilder;

  // send the http request
  Future<BaseHttpResponse<T>> send() {
    return NetworkService.instance // to make asynchronous requests
        .sendHTTPSRequest(_endPoint, _httpVerb, _parameters)
        .then(_onSendResult)
        .catchError(_onErrorOccurred);
  }

  // converts the http response to a base http response object through the _responseBuilder
  BaseHttpResponse<T> _onSendResult(Response response) {
    _responseArrived = true;
    return _responseBuilder.generateResponse(response,
        requestParams: _parameters);
  }

  Future<BaseHttpResponse<T>> _onErrorOccurred(Object e) async {
    return _responseBuilder.generateResponse(null, requestParams: _parameters);
  }
}
