import 'dart:io';
import 'package:study_buds/models/group.dart';

import '../../network/base_http_request.dart';
import '../../api/responses/group_creation_response_builder.dart';
import '../../network/network_service.dart';

class GroupCreationRequest
    extends BaseHttpRequest<GroupCreationResponseBuilder, Group> {
  GroupCreationRequest({
    required String name,
    required String description,
    required String course,
    required bool isPublic,
    required int membersLimit,
    required String telegramLink,
    required int studentId,
  }) : super(
          httpVerb: HttpVerb.POST,
          endPoint:
              "${String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:5000')}/groups/create",
          responseBuilder: GroupCreationResponseBuilder(),
          parameters: {
            'name': name,
            'description': description,
            'course': course,
            'isPublic': isPublic,
            'membersLimit': membersLimit,
            'telegramLink': telegramLink,
            'studentId': studentId,
          },
        );
}


/*
Example of usage


void createGroup() async {
  // Example group details
  final String name = "Study Group 101";
  final String description = "A group for math enthusiasts.";
  final String course = "Mathematics";
  final bool isPublic = true;
  final int membersLimit = 50;
  final String telegramLink = "https://t.me/math_group";
  final int studentId = 12345;

  // Create the request
  final creationRequest = GroupCreationRequest(
    name: name,
    description: description,
    course: course,
    isPublic: isPublic,
    membersLimit: membersLimit,
    telegramLink: telegramLink,
    studentId: studentId,
  );

  try {
    // Send the request and await the response
    final response = await creationRequest.send();

    if (response.requestFailed) {
      print("Group creation failed. Status Code: ${response.statusCode}");
    } else {
      // Access the created group
      final Group? group = response.data;
      if (group != null) {
        print("Group created successfully!");
        print("Name: ${group.name}, Description: ${group.description}");
      } else {
        print("Group creation succeeded, but no group data was returned.");
      }
    }
  } catch (e) {
    print("An error occurred during group creation: $e");
  }
}

*/
