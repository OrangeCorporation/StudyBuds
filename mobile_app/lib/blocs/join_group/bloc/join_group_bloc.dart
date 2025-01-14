import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:study_buds/network/request/join_group_request.dart';

part 'join_group_event.dart';
part 'join_group_state.dart';

class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {
  JoinGroupBloc() : super(JoinGroupInitial()) {
    on<JoinGroupRequestEvent>((event, emit) async {
      emit(JoinGroupRequestLoading());
      try {
        final response = await JoinGroupRequest(event.groupId).send();
        if (response.isSuccess) {
          emit(JoinGroupRequestSuccess(response.data, event.groupId));
        } else {
          emit(JoinGroupRequestFailed(response.data, event.groupId));
        }
      } catch (error) {
        emit(JoinGroupRequestFailed('Failed to join group.', event.groupId));
      }
    });
  }
}
