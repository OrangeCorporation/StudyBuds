import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/blocs/group_details/bloc/group_details_bloc.dart';
import 'package:study_buds/blocs/join_group/bloc/join_group_bloc.dart';
import 'package:study_buds/widgets/custom_filled_button.dart';
import 'package:study_buds/widgets/custom_text_button.dart';
import 'package:study_buds/widgets/group_details_dialog.dart';

import '../models/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final num index;
  final Color? backgroundColor;
  final String? buttonLabel;
  final Color? additionalButtonColor;
  final String additionalButtonLabel;

  const GroupCard({
    super.key,
    required this.group,
    required this.index,
    this.backgroundColor,
    this.buttonLabel,
    this.additionalButtonColor,
    this.additionalButtonLabel = "See more",
  });

  showGroupDetails(BuildContext context) {
    final groupDetailsBloc = context.read<GroupDetailsBloc>();
    groupDetailsBloc.add(FetchGroupDetailsEvent(group.id ?? 0));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: groupDetailsBloc,
          child: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
            builder: (context, state) {
              if (state is GroupDetailsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GroupDetailsSuccess) {
                return GroupDetailsDialog(
                  group: group,
                );
              } else if (state is GroupDetailsFailure) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(state.error),
                  actions: [
                    CustomTextButton(
                      label: 'Close',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinGroupBloc, JoinGroupState>(
      listenWhen: (prev, current) {
        if (current is JoinGroupRequestSuccess && current.groupId == group.id) {
          return true;
        }
        if (current is JoinGroupRequestFailed && current.groupId == group.id) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is JoinGroupRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        } else if (state is JoinGroupRequestFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => showGroupDetails(context),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              color: backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  group.name,
                                  key: Key('group_name_${index.toString()}'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(width: 4),
                              IconTheme(
                                data: IconThemeData(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Icon(
                                  group.isPublic ? Icons.lock_open : Icons.lock,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.group),
                            SizedBox(width: 4),
                            Text(
                              '${group.membersCount} members',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Flexible(
                      child: Text(
                        group.course,
                        key: Key('group_course_${index.toString()}'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      group.description,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (additionalButtonLabel == "Delete the group") ...[
                          CustomFilledButton(
                            key: ValueKey('see_more_$index'),
                            backgroundColor: additionalButtonColor ??
                                Theme.of(context).colorScheme.primary,
                            label: additionalButtonLabel,
                            onPressed: () {
                              if (additionalButtonLabel == "See more") {
                                showGroupDetails(context);
                              } else if (additionalButtonLabel ==
                                  "Delete the group") {
                                // TODO: Delete the group functionality
                              }
                            },
                          ),
                        ] else
                          CustomTextButton(
                            key: ValueKey('see_more_$index'),
                            foregroundColor: additionalButtonColor ??
                                Theme.of(context).colorScheme.primary,
                            label: additionalButtonLabel,
                            onPressed: () {
                              if (additionalButtonLabel == "See more") {
                                showGroupDetails(context);
                              } else if (additionalButtonLabel ==
                                  "Delete the group") {
                                // TODO: Delete the group functionality
                              }
                            },
                          ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 4)),
                        if (additionalButtonLabel != "Delete the group")
                          CustomFilledButton(
                            key: Key('join_button_${group.id}'),
                            isEnabled: group.isGroupMember
                                ? false
                                : (group.joinRequestStatus == 'pending' ? false : true),
                            label: group.isGroupAdmin
                                ? "Owned by You"
                                : (group.isGroupMember
                                ? "Already a Member"
                                : (buttonLabel ??
                                (group.joinRequestStatus.isNotEmpty && group.joinRequestStatus != 'reject'
                                    ? group.joinRequestStatus!
                                    : (group.isPublic
                                    ? 'Join the group'
                                    : 'Send a join request')))),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              context.read<JoinGroupBloc>().add(
                                    JoinGroupRequestEvent(group.id ?? 0),
                                  );
                            },
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          if (context.watch<JoinGroupBloc>().state is JoinGroupRequestLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}