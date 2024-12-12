import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/blocs/group_list/bloc/group_list_bloc.dart';
import 'package:study_buds/blocs/join_group/bloc/join_group_bloc.dart';
import 'package:study_buds/models/group.dart';
import 'package:study_buds/widgets/group_card.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Group> joinedGroupList = [];
    List<Group> ownedGroupList = [];

    return Scaffold(
        body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Groups', style: TextStyle(color: Colors.white)),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              overlayColor: WidgetStatePropertyAll(Color(0x25FFFFFF)),
              indicatorColor: Theme.of(context).colorScheme.secondary,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: 'Joined Groups'),
                Tab(text: 'Owned Groups'),
              ],
            ),
          ),
          body: BlocProvider(
          create: (_) => GroupListBloc()..add(FetchMyGroupListEvent(4943369)),
          child: Scaffold(
                body: BlocConsumer<GroupListBloc, GroupListState>(
                    listener: (context, state) {
              if (state is GroupListSuccess){
                joinedGroupList = state.joinedGroups;
                ownedGroupList = state.myGroups;
              }
            },
          builder: (context, state) {
          return TabBarView(
            children: [
              GroupListTab(
                groups: joinedGroupList,
                isJoinedScreen: true,
              ),
              GroupListTab(
                groups: ownedGroupList,
                isJoinedScreen: false,
              ),
            ],
          );
          },
        ),
      ),
      ),
    ),
        ),
    );
  }
}

class GroupListTab extends StatelessWidget {
  final List<Group> groups; // it could be a list of owned or joined groups
  final bool isJoinedScreen;

  const GroupListTab(
      {super.key, required this.groups, this.isJoinedScreen = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
            // Add vertical and horizontal padding
            child: BlocProvider<JoinGroupBloc>(
                  create: (_) => JoinGroupBloc(),
                  child: GroupCard(
              backgroundColor: Colors.white,
              buttonLabel:
                  isJoinedScreen ? "Leave the group" : "Change settings",
              additionalButtonLabel:
                  isJoinedScreen ? "See more" : "Delete the group",
              additionalButtonColor: isJoinedScreen
                  ? Theme.of(context).colorScheme.primary
                  : Colors.red,
              group: group,
               index: index,
            ),
          ),
          );
        },
      ),
    );
  }
}
