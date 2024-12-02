import 'package:study_buds/models/group.dart';
import 'dart:io';

import '../requests/basic_search_request.dart'; // Import to access environment variables

// $env:API_URL="http://10.0.2.2:5000"

void performBasicSearch(String query, int studentId) async {
  // Create the request
  final searchRequest = BasicSearchRequest(query: query, studentId: studentId);
  print("--+++++++++++++++++++++++");
  print(String.fromEnvironment('API_URL', defaultValue: '10.0.2.2:5000'));
  print("----++++++++++++++++++++");
  try {
    // Send the request and await the response
    final response = await searchRequest.send();

    if (response.requestFailed) {
      print("Search request failed. Status Code: ${response.statusCode}");
    } else {
      // Access the list of groups
      final List<dynamic> groupCards = response.data ?? [];
      print("Search succeeded! Found ${groupCards.length} groups.");

      for (final groupCard in groupCards) {
        print("groupCard: ${groupCard}");
      }
    }
  } catch (e) {
    print("An error occurred during the search: $e");
  }
}

void main() {
  performBasicSearch("adm", 6139355);
}
