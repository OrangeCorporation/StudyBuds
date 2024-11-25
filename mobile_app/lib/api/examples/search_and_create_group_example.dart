import 'api/requests/group_search_request.dart';
import 'api/requests/group_creation_request.dart';
import 'models/group.dart';

void searchAndCreateGroupExample(String query, int studentId) async {
  print("Searching for groups with query: $query...");

  // Search for groups
  final searchRequest = GroupSearchRequest(
    text: query,
    studentId: studentId,
  );

  final searchResponse = await searchRequest.send();

  if (searchResponse.requestFailed) {
    print("Failed to search for groups.");
    return;
  }

  List<Group>? groups = searchResponse.data;

  if (groups != null && groups.isNotEmpty) {
    print("Groups found:");
    for (var group in groups) {
      print("- ${group.name} (${group.course}): ${group.members} members");
    }
  } else {
    print("No groups found. Creating a new group...");

    // Create a new group
    final creationRequest = GroupCreationRequest(
      name: "New Study Group for $query",
      description: "A group created for $query enthusiasts.",
      course: query,
      isPublic: true,
      membersLimit: 20,
      telegramLink: "https://t.me/new_$query_group",
      studentId: studentId,
    );

    final creationResponse = await creationRequest.send();

    if (creationResponse.requestFailed) {
      print("Failed to create the group.");
    } else {
      Group? newGroup = creationResponse.data;

      if (newGroup != null) {
        print("New group created successfully!");
        print("Group Name: ${newGroup.name}");
        print("Course: ${newGroup.course}");
        print("Description: ${newGroup.description}");
      }
    }
  }
}
