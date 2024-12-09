import 'package:flutter/material.dart';
import 'package:study_buds/models/notification_model.dart';
import 'package:study_buds/widgets/custom_filled_button.dart';

class NotificationPopup extends StatelessWidget {
  final String acceptButtonLabel;
  final String rejectButtonLabel;
  final NotificationModel notification;

  const NotificationPopup({
    Key? key,
    required this.acceptButtonLabel,
    required this.rejectButtonLabel,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 320,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Decline Button
            Container(
              width: 60,
              child: CustomFilledButton(
                label: rejectButtonLabel,
                iconData: Icons.cancel,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                rotationAngle: -1.57,
                backgroundColor: const Color(0xFFD90429),
                foregroundColor: Colors.white,
                width: 80,
                height: double.infinity,
              ),
            ),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      notification.notificationType,
                      style: const TextStyle(
                        color: Color(0xFF252B33),
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notification.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF252B33),
                        fontSize: 14,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: 60,
              child: CustomFilledButton(
                label: acceptButtonLabel,
                iconData: Icons.check_circle,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                rotationAngle: 1.57,
                backgroundColor: const Color(0xFF252B33),
                foregroundColor: Colors.white,
                width: 80,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}