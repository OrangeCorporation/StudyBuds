import 'package:study_buds/network/base_http_request.dart';
import 'package:study_buds/network/network_service.dart';
import 'package:study_buds/network/response/notification_list_response.dart';

class NotificationListRequest
    extends BaseHttpRequest<NotificationListResponseBuilder, List<dynamic>> {
  NotificationListRequest()
      : super(
          httpVerb: HttpVerb.GET,
          endPoint: "/notification/list",
          responseBuilder: NotificationListResponseBuilder(),
        );
}
