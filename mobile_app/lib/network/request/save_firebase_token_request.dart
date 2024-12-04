import 'package:study_buds/network/netwrok_service.dart';
import 'package:study_buds/network/response/save_firebase_token_response.dart';

import '../../network/base_http_request.dart';

class SaveFirebaseTokenRequest
    extends BaseHttpRequest<SaveFirebaseTokenResponse, String> {
  SaveFirebaseTokenRequest({required String token, required int studentId})
      : super(
          httpVerb: HttpVerb.POST,
          endPoint: "/notification/token",
          parameters: {
            'token': token,
            'student_id': studentId
          },
          responseBuilder: SaveFirebaseTokenResponse(),
        );
}