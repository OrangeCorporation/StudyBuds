import '../../network/base_http_response.dart';

class SuggestedGroupsResponseBuilder
    extends BaseHttpResponseBuilder<List<dynamic>> {
  SuggestedGroupsResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return jsonObject;
        });
}
