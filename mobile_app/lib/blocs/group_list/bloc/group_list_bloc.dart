import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/models/group.dart';
import 'package:study_buds/network/request/fetch_my_group_list_request.dart';

part 'group_list_event.dart';
part 'group_list_state.dart';

class GroupListBloc extends Bloc<GroupListEvent, GroupListState> {
  GroupListBloc() : super(GroupListInitial()) {
    on<FetchMyGroupListEvent>((event, emit) async {
      emit(GroupListLoading());
      try {
        final fetchNotificationRequest =
            FetchMyGroupListRequest();
        final response = await fetchNotificationRequest.send();
        if (response.isSuccess) {
          dynamic data = response.data;
          if (data != null) {
            List<Group> ownedGroups =
                Group.fromJsonList(data['ownedGroups']);
            List<Group> joinedGroups =
                Group.fromJsonList(data['joinedGroups']);
            emit(GroupListSuccess(ownedGroups, joinedGroups));
          }
        } else {
          emit(GroupListFailure('Failed to load my group list'));
        }
      } catch (error) {
        print('Error fetching my group list: $error');
        emit(GroupListFailure('Failed to fetch my group list'));
      }
    });
  }
}
