import 'package:study_buds/models/group.dart';
import 'dart:io';

import '../requests/basic_search_request.dart'; // Import to access environment variables

void performBasicSearch(String query, int studentId) async {
  // Create the request
  final searchRequest = BasicSearchRequest(query: query, studentId: studentId);

  try {
    // Send the request and await the response
    final response = await searchRequest.send();
    print("----oo");
    print(Platform.environment['API_URL']);
    print("----oo");
    if (response.requestFailed) {
      print("Search request failed. Status Code: ${response.statusCode}");
    } else {
      // Access the list of groups
      final List<Group> groups = response.data ?? [];
      print("Search succeeded! Found ${groups.length} groups.");

      for (final group in groups) {
        print("Group: ${group.name}, Course: ${group.course}");
      }
    }
  } catch (e) {
    print("An error occurred during the search: $e");
  }
}

void main() {
  performBasicSearch("adm", 6139355);
}
