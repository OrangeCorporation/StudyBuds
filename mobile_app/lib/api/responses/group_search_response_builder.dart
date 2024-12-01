import 'package:study_buds/models/group.dart';

import '../../network/base_http_response.dart';

class GroupSearchResponseBuilder extends BaseHttpResponseBuilder<List<Group>> {
  GroupSearchResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return jsonObject[0];
        });
}
