import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/blocs/join_request/bloc/join_request_bloc.dart';
import 'package:study_buds/models/notification.dart';
import 'package:study_buds/utils/date_utils.dart';
import 'package:study_buds/widgets/custom_icon_button.dart';
import 'package:study_buds/widgets/notification_popup.dart';

class NotificationCard extends StatelessWidget {
  final Color? backgroundColor;
  final String? buttonLabel;
  final NotificationModel notification;
  final Function listChanged;

  const NotificationCard({
    super.key,
    this.backgroundColor,
    this.buttonLabel,
    required this.notification,
    required this.listChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    IconTheme(
                      data: IconThemeData(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Icon(
                        notification.notificationType == 'join_request'
                            ? Icons.group
                            : (notification.notificationType == 'accept'
                                ? Icons.check_circle
                                : Icons.cancel),
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      DateTimeUtils.dateDiffToString(notification.createdAt),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                  ],
                ),
              ],
            ),
            SizedBox(width: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key: ValueKey("notification_${notification.id}"),
                        notification.message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                BlocProvider(
                  create: (_) => JoinRequestBloc(),
                  child: BlocListener<JoinRequestBloc, JoinRequestState>(
                      listener: (context, state) {
                        if (state is JoinRequestLoading) {
                          print("WROOOONG");
                          // do nothing
                        } else if (state is JoinRequestSuccess) {
                          print("SUCCCEESSSSS");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    key: Key("success_toast"), state.message),
                                backgroundColor: Colors.green),
                          );
                          listChanged.call();
                        } else if (state is JoinRequestFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text(key: Key("fail_toast"), state.error),
                                backgroundColor: Colors.red),
                          );
                          listChanged.call();
                        } else
                          print("WRROOOOOOOG@");
                      },
                      child: (notification.notificationType == 'join_request' &&
                              notification.joinRequestStatus == 'pending')
                          ? AcceptButton(
                              notification: notification,
                              listChanged: listChanged,
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  key: ValueKey(notification.joinRequestId),
                                  notification.joinRequestStatus + 'ed',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: notification.joinRequestStatus ==
                                            'accept'
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AcceptButton extends StatelessWidget {
  final NotificationModel notification;
  final Function listChanged;

  const AcceptButton(
      {super.key, required this.notification, required this.listChanged});

  @override
  Widget build(BuildContext sb) {
    return CustomIconButton(
      key: ValueKey("btn_${notification.id}"),
      onPressed: () {
        showDialog(
          context: sb,
          builder: (BuildContext context) {
            return NotificationPopup(
                key: ValueKey("popup"),
                acceptButtonLabel: 'Accept',
                rejectButtonLabel: 'Reject',
                notification: notification,
                listChanged: listChanged,
                sb: sb);
          },
        );
      },
      iconData: Icons.chevron_right_outlined,
    );
  }
}
