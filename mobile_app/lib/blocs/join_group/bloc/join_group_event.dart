part of 'join_group_bloc.dart';

sealed class JoinGroupEvent extends Equatable {
  

  const JoinGroupEvent();
}


class JoinGroupRequestEvent extends JoinGroupEvent {
  final int groupId;
  
  const JoinGroupRequestEvent(this.groupId);
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}