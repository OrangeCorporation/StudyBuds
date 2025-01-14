import '../../network/base_http_response.dart';

class UpdateFireabaseTokenResponseBuilder
    extends BaseHttpResponseBuilder<List<dynamic>> {
  UpdateFireabaseTokenResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return jsonObject;
        });
}
