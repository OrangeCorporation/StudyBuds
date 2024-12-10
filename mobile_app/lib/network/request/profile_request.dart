import 'package:study_buds/network/base_http_request.dart';
import 'package:study_buds/network/netwrok_service.dart';
import 'package:study_buds/network/response/profile_response.dart';

class ProfileRequest extends BaseHttpRequest<ProfileResponseBuilder, dynamic> {
  ProfileRequest(int studentId)
      : super(
            httpVerb: HttpVerb.GET,
            endPoint: "/profile/$studentId",
            responseBuilder: ProfileResponseBuilder());
}
