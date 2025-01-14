import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/group_search_build.dart';

import '../../network/base_http_request.dart';

class BasicSearchRequest
    extends BaseHttpRequest<GroupSearchResponseBuilder, List<dynamic>> {
  BasicSearchRequest({required String query})
      : super(
          httpVerb: HttpVerb.GET,
          endPoint: "/groups/basic_search/$query",
          responseBuilder: GroupSearchResponseBuilder(),
        );
}
