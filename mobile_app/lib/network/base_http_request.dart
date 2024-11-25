import 'package:http/http.dart';
import '../network/base_http_response.dart';
import '../network/network_service.dart';

abstract class BaseHttpRequest<B extends BaseHttpResponseBuilder<T>, T> {
  HttpVerb _httpVerb;
  String _endPoint;
  Map<String, dynamic> _parameters;
  B _responseBuilder;
  bool _responseArrived = false;

  BaseHttpRequest({
    required HttpVerb httpVerb,
    required String endPoint,
    required B responseBuilder,
    Map<String, dynamic> parameters = const {},
  })  : _httpVerb = httpVerb,
        _endPoint = endPoint,
        _parameters = parameters,
        _responseBuilder = responseBuilder;

  Future<BaseHttpResponse<T>> send() {
    return NetworkService.instance
        .sendHTTPSRequest(_endPoint, _httpVerb, _parameters)
        .then(_onSendResult)
        .catchError(_onErrorOccurred);
  }

  BaseHttpResponse<T> _onSendResult(Response response) {
    _responseArrived = true;
    return _responseBuilder.generateResponse(response,
        requestParams: _parameters);
  }

  Future<BaseHttpResponse<T>> _onErrorOccurred(Object e) async {
    return _responseBuilder.generateResponse(null, requestParams: _parameters);
  }
}
