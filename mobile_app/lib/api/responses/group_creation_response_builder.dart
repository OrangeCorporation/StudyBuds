import '../../network/base_http_response.dart';
import '../../models/group.dart';

// converts the json object from the response to a group object
class GroupCreationResponseBuilder extends BaseHttpResponseBuilder<Group> {
  GroupCreationResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return Group.fromJson(jsonObject);
        });
}
