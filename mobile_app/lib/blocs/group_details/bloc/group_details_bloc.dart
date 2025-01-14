import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:study_buds/models/group.dart';
import 'package:study_buds/network/request/group_details_request.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  GroupDetailsBloc() : super(GroupDetailsInitial()) {
    on<FetchGroupDetailsEvent>((event, emit) async {
      emit(GroupDetailsLoading());
      try {
        final request = GroupDetailsRequest(event.groupId);
        final response = await request.send();
        if (response.isSuccess) {
          emit(GroupDetailsSuccess(Group.fromJson(response.data)));
        } else {
          emit(GroupDetailsFailure('Failed to fetch details.'));
        }
      } catch (error) {
        print(error);
        emit(GroupDetailsFailure('An error occurred while fetching details.'));
      }
    });
  }
}
