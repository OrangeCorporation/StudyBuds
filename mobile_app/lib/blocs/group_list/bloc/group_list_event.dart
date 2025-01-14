part of 'group_list_bloc.dart';

sealed class GroupListEvent extends Equatable {

  const GroupListEvent();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class FetchMyGroupListEvent extends GroupListEvent {
  const FetchMyGroupListEvent();

}
