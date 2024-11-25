/*
Rationale for This Structure
Separation of Concerns: Each component has a clear responsibility (e.g., models, network handling, API requests).
Scalability: Easy to add new requests, responses, or models without disrupting the existing structure.
Reusability: Common utilities (e.g., BaseHttpRequest, NetworkService) are centralized and reusable.
*/

import '../../network/base_http_request.dart';
import '../../api/responses/group_search_response_builder.dart';
import '../../models/group.dart';
import '../../network/network_service.dart';

class BasicSearchRequest
    extends BaseHttpRequest<GroupSearchResponseBuilder, List<Group>> {
  BasicSearchRequest({required String query, required int studentId})
      : super(
          httpVerb: HttpVerb.GET,
          endPoint:
              "http://10.0.2.2:5000/groups/basic_search/$query/$studentId",
          responseBuilder: GroupSearchResponseBuilder(),
        );
}
