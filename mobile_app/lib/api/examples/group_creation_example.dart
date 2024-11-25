import 'api/requests/group_creation_request.dart';
import 'models/group.dart';

void createGroupExample() async {
  print("Creating a new group...");

  // Initialize the creation request
  final request = GroupCreationRequest(
    name: "Science Study Group",
    description: "A group for science enthusiasts.",
    course: "Physics 101",
    isPublic: true,
    membersLimit: 15,
    telegramLink: "https://t.me/example_group",
    studentId: 123,  // Replace with the creator's student ID
  );

  // Send the request
  final response = await request.send();

  // Handle the response
  if (response.requestFailed) {
    print("Failed to create the group.");
  } else {
    Group? createdGroup = response.data;

    if (createdGroup != null) {
      print("Group created successfully!");
      print("Group Name: ${createdGroup.name}");
      print("Course: ${createdGroup.course}");
      print("Description: ${createdGroup.description}");
      print("Public: ${createdGroup.isPublic}");
      print("Members Limit: ${createdGroup.membersLimit}");
    }
  }
}
