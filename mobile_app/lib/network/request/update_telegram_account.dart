import 'package:study_buds/network/base_http_request.dart';
import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/profile_response.dart';

class UpdateTelegramAccountRequest extends BaseHttpRequest<ProfileResponseBuilder, dynamic> {
  UpdateTelegramAccountRequest(int telegramAccount)
      : super(
            httpVerb: HttpVerb.POST,
            endPoint: "/profile/edit_telegram_account",
            responseBuilder: ProfileResponseBuilder(),
            parameters: {
            'telegramAccount': telegramAccount
          },);
}
