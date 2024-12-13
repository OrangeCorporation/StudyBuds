import 'package:study_buds/network/base_http_request.dart';
import 'package:study_buds/network/netwrok_service.dart';
import 'package:study_buds/network/response/fetch_my_group_list_response.dart';

class FetchMyGroupListRequest
    extends BaseHttpRequest<FetchMyGroupListResponseBuilder, dynamic> {
  FetchMyGroupListRequest(int studentId)
      : super(
          httpVerb: HttpVerb.GET,
          endPoint: "/groups/joined_groups/$studentId",
          responseBuilder: FetchMyGroupListResponseBuilder(),
        );
}
