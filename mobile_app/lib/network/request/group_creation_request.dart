import 'package:study_buds/models/group.dart';
import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/group_creation_response.dart';

import '../../network/base_http_request.dart';

class GroupCreationRequest
    extends BaseHttpRequest<GroupCreationResponseBuilder, dynamic> {
  GroupCreationRequest(Group group)
      : super(
          httpVerb: HttpVerb.POST,
          endPoint: "/groups/create",
          responseBuilder: GroupCreationResponseBuilder(),
          parameters: {
            'name': group.name,
            'course': group.course,
            'description': group.description,
            'isPublic': group.isPublic,
            'telegramLink': group.telegramLink,
            'studentId': group.ownerId,
            'membersCount': group.membersCount,
            'membersLimit': group.membersLimit,
            'members': group.members
          },
        );
}
