import '../../network/base_http_response.dart';

// converts the json object from the response to a group object
class SaveFirebaseTokenResponse extends BaseHttpResponseBuilder<String> {
  SaveFirebaseTokenResponse()
      : super(dataFactory: (jsonObject) {
          return jsonObject['message'];
        });
}