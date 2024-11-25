import 'api/requests/group_search_request.dart';

void searchGroupsWithErrorHandling() async {
  print("Searching for groups...");

  try {
    final request = GroupSearchRequest(
      text: "chemistry",
      studentId: 123,
    );

    final response = await request.send();

    if (response.requestFailed) {
      print("Request failed. Please check your network connection.");
    } else {
      List<Group>? groups = response.data;

      if (groups != null && groups.isNotEmpty) {
        print("Groups found:");
        for (var group in groups) {
          print("- ${group.name} (${group.course})");
        }
      } else {
        print("No groups found.");
      }
    }
  } catch (e) {
    print("An unexpected error occurred: $e");
  }
}
