import '../../network/base_http_response.dart';
import '../../models/group.dart';

class GroupCreationResponseBuilder extends BaseHttpResponseBuilder<Group> {
  GroupCreationResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return Group.fromJson(jsonObject);
        });
}
