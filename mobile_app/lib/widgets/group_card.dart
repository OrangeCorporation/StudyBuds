import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  GroupCard({required this.group});

  Future<void> joinGroup(int studentId, int groupId) async {
    final url = Uri.parse('http://10.0.2.2:5000/groups/join');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'studentId': studentId,
          'groupId': groupId,
        }),
      );

      if (response.statusCode == 200) {
        // Success
        Fluttertoast.showToast(
          msg: group.isPublic
              ? 'Successfully joined the group!'
              : 'Join request sent successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        // Failure
        final responseBody = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: responseBody['message'] ?? 'Failed to join the group.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      // Error
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Name and lock icon
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
                        color: Colors.black, // Explicitly set color to black
                      ),
                      child: Icon(
                        group.isPublic ? Icons.lock_open : Icons.lock,
                      ),
                    ),
                  ],
                ),
                // Members count
                Row(
                  children: [
                    Icon(Icons.group),
                    SizedBox(width: 4),
                    Text('${group.members} members'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),

            // Course name
            Text(
              group.course, // New field for course name
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            SizedBox(height: 8),

            // Description
            Text(
              group.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),

            // Join button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Hardcoded studentId (replace with actual studentId)
                  joinGroup(234, group.id); // Replace 234 with actual studentId
                },
                child: Text(group.isPublic ? 'Join' : 'Send a join request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
