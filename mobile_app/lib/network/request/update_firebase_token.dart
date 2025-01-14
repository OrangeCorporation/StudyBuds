import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/update_fireabase_token_response.dart';

import '../../network/base_http_request.dart';

class UpdateFirebaseToken
    extends BaseHttpRequest<UpdateFireabaseTokenResponseBuilder, List<dynamic>> {
  UpdateFirebaseToken(String token)
      : super(
          httpVerb: HttpVerb.POST,
          endPoint: "/notification/token",
          responseBuilder: UpdateFireabaseTokenResponseBuilder(),
          parameters: {
            'token': token
          },
        );
}
