import 'package:study_buds/models/group.dart';
import 'dart:io';

import '../requests/basic_search_request.dart'; // Import to access environment variables

void performBasicSearch(String query, int studentId) async {
  final searchRequest = BasicSearchRequest(query: query, studentId: studentId);

  try {
    final response = await searchRequest.send();
    print("----oo");
    print("Base URL: ${Platform.environment['API_URL']}");
    print("----oo");

    if (response.requestFailed) {
      print("Search request failed. Status Code: ${response.statusCode}");
      print("Response body: ${response.data}");
    } else {
      final List<Group> groups = response.data ?? [];
      print("Search succeeded! Found ${groups.length} groups.");
      for (final group in groups) {
        print("Group: ${group.name}, Course: ${group.course}");
      }
    }
  } catch (e, stackTrace) {
    print("An error occurred during the search: $e");
    print("Stack trace: $stackTrace");
  }
}

void main() {
  performBasicSearch("adm", 4812579);
}
