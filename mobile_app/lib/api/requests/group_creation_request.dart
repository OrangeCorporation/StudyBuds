import '../../network/base_http_request.dart';
import '../../api/responses/group_creation_response_builder.dart';
import '../../models/group.dart';
import '../../network/network_service.dart';

class GroupCreationRequest
    extends BaseHttpRequest<GroupCreationResponseBuilder, Group> {
  GroupCreationRequest({
    required String name,
    required String description,
    required String course,
    required bool isPublic,
    required int membersLimit,
    required String telegramLink,
    required int studentId,
  }) : super(
          httpVerb: HttpVerb.POST,
          endPoint: "http://10.0.2.2:5000/groups/create",
          responseBuilder: GroupCreationResponseBuilder(),
          parameters: {
            'name': name,
            'description': description,
            'course': course,
            'isPublic': isPublic,
            'membersLimit': membersLimit,
            'telegramLink': telegramLink,
            'studentId': studentId,
          },
        );
}
