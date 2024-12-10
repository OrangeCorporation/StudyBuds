import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:study_buds/network/request/update_join_request.dart';

part 'join_request_event.dart';
part 'join_request_state.dart';

class JoinRequestBloc extends Bloc<JoinRequestEvent, JoinRequestState> {
  JoinRequestBloc() : super(JoinRequestInitial()) {
    on<ChangeJoinRequestStatusEvent>((event, emit) async {
      emit(JoinRequestLoading());
      try {
        final changeJoinRequestStatus = UpdateJoinRequest(
            event.studentId, event.joinRequestId, event.isAccepted);
        final response = await changeJoinRequestStatus.send();
        if (response.isSuccess) {
          emit(JoinRequestSuccess(response.data));
        } else {
          emit(JoinRequestFailed(response.data));
        }
      } catch (error) {
        emit(JoinRequestFailed('Failed to change join request status.'));
      }
    });
  }
}

