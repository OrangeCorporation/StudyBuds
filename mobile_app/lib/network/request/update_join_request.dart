import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/update_join_request_response.dart';

import '../../network/base_http_request.dart';

class UpdateJoinRequest
    extends BaseHttpRequest<UpdateJoinRequestResponseBuilder, dynamic> {
  UpdateJoinRequest(int joinRequestId, bool isAccepted)
      : super(
          httpVerb: HttpVerb.POST,
          endPoint: "/groups/respond_join_request",
          responseBuilder: UpdateJoinRequestResponseBuilder(),
          parameters: {
            'joinRequestId': joinRequestId,
            'isAccepted': isAccepted
          },
        );
}
