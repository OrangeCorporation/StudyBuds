import '../../network/base_http_response.dart';
import '../../models/group.dart';

class GroupSearchResponseBuilder extends BaseHttpResponseBuilder<List<Group>> {
  GroupSearchResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return (jsonObject as List)
              .map((item) => Group.fromJson(item as Map<String, dynamic>))
              .toList();
        });
}
