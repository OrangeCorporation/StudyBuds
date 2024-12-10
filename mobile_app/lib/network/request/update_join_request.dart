import 'package:study_buds/network/netwrok_service.dart';
import 'package:study_buds/network/response/join_group_response.dart';
import 'package:study_buds/network/response/update_join_request_response.dart';

import '../../network/base_http_request.dart';

class UpdateJoinRequest
    extends BaseHttpRequest<UpdateJoinRequestResponseBuilder, dynamic> {
  UpdateJoinRequest(int studentId, int joinRequestId, bool isAccepted)
      : super(
          httpVerb: HttpVerb.POST,
          endPoint: "/groups/respond_join_request",
          responseBuilder: UpdateJoinRequestResponseBuilder(),
          parameters: {
            'adminId': studentId,
            'joinRequestId': joinRequestId,
            'isAccepted': isAccepted
          },
        );
}