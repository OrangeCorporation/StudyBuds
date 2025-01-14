part of 'group_list_bloc.dart';

@immutable
sealed class GroupListState {}

final class GroupListInitial extends GroupListState {
}


class GroupListLoading extends GroupListState {}

class GroupListSuccess extends GroupListState {
  final List<Group> ownedGroups;
  final List<Group> joinedGroups;

  GroupListSuccess(this.ownedGroups, this.joinedGroups);
}

class GroupListFailure extends GroupListState {
  final String error;
  GroupListFailure(this.error);
}

