import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:study_buds/models/notification.dart';
import 'package:study_buds/network/request/notification_list_request.dart';

part 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  NotificationListBloc() : super(NotificationListInitial()) {
    on<FetchNotificationListEvent>(_fetchNotificationList);
  }

  Future<void> _fetchNotificationList(FetchNotificationListEvent event,
      Emitter<NotificationListState> emit) async {
    emit(NotificationListLoading());
    try {
      final fetchNotificationRequest = NotificationListRequest();
      final response = await fetchNotificationRequest.send();
      if (response.isSuccess) {
        if (response.data != null && response.data!.isNotEmpty) {
          final List<NotificationModel> result =
              NotificationModel.fromJsonList(response.data ?? []);

          List<NotificationModel> receivedList = [];
          List<NotificationModel> responseList = [];
          if (result.isNotEmpty) {
            receivedList = result
                .where((notification) =>
                    notification.notificationType == 'join_request')
                .toList();
            responseList = result
                .where((notification) =>
                    notification.notificationType != 'join_request')
                .toList();
          }
          emit(NotificationListSuccess(receivedList, responseList));
        }
      } else {
        emit(NotificationListFailure('Failed to load notification list'));
      }
    } catch (error) {
      emit(NotificationListFailure('Failed to fetch notification list'));
    }
  }
}
