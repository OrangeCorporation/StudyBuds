import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/suggested_groups_response.dart';

import '../../network/base_http_request.dart';

class SuggestedGroupsRequest
    extends BaseHttpRequest<SuggestedGroupsResponseBuilder, List<dynamic>> {
  SuggestedGroupsRequest()
      : super(
          httpVerb: HttpVerb.GET,
          endPoint: "/groups/group_suggestions",
          responseBuilder: SuggestedGroupsResponseBuilder(),
        );
}
