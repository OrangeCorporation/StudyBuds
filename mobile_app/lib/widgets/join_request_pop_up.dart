import 'package:flutter/material.dart';

class JoinRequestPopup extends StatelessWidget {
  final String title;
  final String message;

  const JoinRequestPopup({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            // Handle accept logic here
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request accepted!')),
            );
          },
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            'Accept',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle reject logic here
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request rejected!')),
            );
          },
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          child: const Text(
            'Reject',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
