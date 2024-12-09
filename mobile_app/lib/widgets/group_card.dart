import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/blocs/join_group/bloc/join_group_bloc.dart';
import 'package:study_buds/widgets/custom_filled_button.dart';
import 'package:study_buds/widgets/custom_text_button.dart';

import '../models/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final Color? backgroundColor;
  final String? buttonLabel;
  final Color? additionalButtonColor;
  final String? additionalButtonLabel;

  const GroupCard({
    super.key,
    required this.group,
    this.backgroundColor,
    this.buttonLabel,
    this.additionalButtonColor,
    this.additionalButtonLabel
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinGroupBloc, JoinGroupState>(
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
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            group.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          IconTheme(
                            data: IconThemeData(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Icon(
                              group.isPublic ? Icons.lock_open : Icons.lock,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.group),
                          SizedBox(width: 4),
                          Text(
                            '${group.members} members',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    group.course,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    group.description,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextButton(
                        foregroundColor: additionalButtonColor ??
                            Theme.of(context).colorScheme.primary,
                        label: additionalButtonLabel ?? "See more",
                        onPressed: () {},
                      ),
                      Container(margin: EdgeInsets.symmetric(horizontal: 5)),
                      CustomFilledButton(
                        isEnabled: group.status == null,
                        label: group.status != null ? group.status! :
                            (group.isPublic
                                ? 'Join the group'
                                : 'Send a join request'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          context.read<JoinGroupBloc>().add(
                                JoinGroupRequestEvent(10, group.id ?? 0),
                              );
                        },
                      ),
                    ],
                  )
                ],
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
