import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/blocs/join_request/bloc/join_request_bloc.dart';
import 'package:study_buds/models/notification.dart';
import 'package:study_buds/widgets/custom_filled_button.dart';
import 'package:study_buds/widgets/custom_text_button.dart';

class NotificationPopup extends StatelessWidget {
  final String acceptButtonLabel;
  final String rejectButtonLabel;
  final NotificationModel notification;
  final Function listChanged;
  final BuildContext sb;

  const NotificationPopup({
    super.key,
    required this.acceptButtonLabel,
    required this.rejectButtonLabel,
    required this.notification,
    required this.listChanged,
    required this.sb,
  });

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: Text(notification.notificationType),
        content: Text(notification.message),
        actions: [
          CustomTextButton(
            key: ValueKey("reject"),
            onPressed: () {
              sb.read<JoinRequestBloc>().add(ChangeJoinRequestStatusEvent(
                  notification.joinRequestId, false));
              Navigator.of(context).pop();
            },
            label: rejectButtonLabel,
            iconData: Icons.cancel_rounded,
            foregroundColor: Colors.red,
          ),
          SizedBox(width: 2),
          CustomFilledButton(
            key: ValueKey("accept"),
            onPressed: () {
              sb.read<JoinRequestBloc>().add(ChangeJoinRequestStatusEvent(
                  notification.joinRequestId, true));
              Navigator.of(context).pop();
            },
            iconData: Icons.check_circle_rounded,
            label: acceptButtonLabel,
          ),
        ],
      );
  }
}
