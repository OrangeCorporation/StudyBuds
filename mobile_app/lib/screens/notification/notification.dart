import 'package:flutter/material.dart';
import 'package:study_buds/widgets/join_request_pop_up.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> notifications = [
    {
      'type': 'join_request',
      'title': 'Join request',
      'message': 'Name lastname wants to join "Group name".'
    },
    {
      'type': 'join_result',
      'title': 'Join request result',
      'message': 'Your request to join "Group name" was approved.'
    },
    {
      'type': 'join_request',
      'title': 'Join request',
      'message': 'Name lastname wants to join "Group name".'
    },
    {
      'type': 'join_result_rejected',
      'title': 'Join request result',
      'message': 'Your request to join "Group name" was declined.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () {
              if (notification['type'] == 'join_request') {
                // Show the popup for join requests
                showDialog(
                  context: context,
                  builder: (context) => JoinRequestPopup(
                    title: notification['title']!,
                    message: notification['message']!,
                  ),
                );
              }
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(
                  notification['type'] == 'join_request'
                      ? Icons.group_add
                      : Icons.check_circle,
                  color: notification['type'] == 'join_request'
                      ? Colors.blue
                      : Colors.green,
                ),
                title: Text(notification['title']!),
                subtitle: Text(notification['message']!),
              ),
            ),
          );
        },
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text(
  //           'Notifications',
  //           style: TextStyle(fontWeight: FontWeight.w600),
  //         ),
  //         centerTitle: true,
  //         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //         elevation: 0,
  //         foregroundColor: Theme.of(context).primaryColor,
  //       ),
  //     body: const Center(
  //       child: Text('This is the Notification screen'),
  //     ),
  //   );
  // }
}
