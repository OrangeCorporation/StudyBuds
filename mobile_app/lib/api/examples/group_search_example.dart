import 'api/requests/group_search_request.dart';
import 'models/group.dart';

void searchGroupsExample() async {
  print("Searching for groups...");
  
  // Initialize the search request
  final request = GroupSearchRequest(
    text: "math",  // Replace with the desired query
    studentId: 123,  // Replace with the student's ID
  );

  // Send the request
  final response = await request.send();

  // Handle the response
  if (response.requestFailed) {
    print("Failed to fetch groups.");
  } else {
    List<Group>? groups = response.data;

    if (groups != null && groups.isNotEmpty) {
      print("Groups found:");
      for (var group in groups) {
        print("- ${group.name} (${group.course}): ${group.members} members");
      }
    } else {
      print("No groups matched the query.");
    }
  }
}
