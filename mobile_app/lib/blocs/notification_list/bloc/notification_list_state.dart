part of 'notification_list_bloc.dart';

@immutable
sealed class NotificationListState {
  final bool isLoading = false;
}

class NotificationListInitial extends NotificationListState {}

class NotificationListLoading extends NotificationListState {}

class NotificationListSuccess extends NotificationListState {
  final List<NotificationModel> received;
  final List<NotificationModel> responseList;
  NotificationListSuccess(this.received, this.responseList);
}

class NotificationListFailure extends NotificationListState {
  final String error;
  NotificationListFailure(this.error);
}

