import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/join_group_response.dart';

import '../../network/base_http_request.dart';

class JoinGroupRequest
    extends BaseHttpRequest<JoinGroupResponseBuilder, dynamic> {
  JoinGroupRequest(int groupId) : super(
          httpVerb: HttpVerb.POST,
          endPoint:"/groups/join",
          responseBuilder: JoinGroupResponseBuilder(),
          parameters: {
            'groupId': groupId
          },
        );
}
