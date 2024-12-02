import 'package:study_buds/api/requests/group_creation_request.dart';
import 'package:study_buds/models/group.dart';

void createGroup() async {
  // Example group details
  final String name = "Study Group 101";
  final String description = " kk";
  final String course = "ADM";
  final bool isPublic = true;
  final int membersLimit = 50;
  final String telegramLink = "https://t.me/math_group";
  final int studentId = 4812579;

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
    print(response.requestParams);
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

void main() {
  createGroup();
}
