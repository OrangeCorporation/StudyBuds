/*
In this folder files define specific API requests that extend the abstract
framework defined in the folder lib/network


*/
import 'dart:io'; // Import to access environment variables
import 'package:study_buds/models/group.dart';

import '../../network/base_http_request.dart';
import '../../api/responses/group_search_response_builder.dart';

import '../../network/network_service.dart';

class BasicSearchRequest
    extends BaseHttpRequest<GroupSearchResponseBuilder, List<Group>> {
  BasicSearchRequest({required String query, required int studentId})
      : super(
          httpVerb: HttpVerb.GET,
          endPoint: "/groups/basic_search/$query/$studentId",
          responseBuilder: GroupSearchResponseBuilder(),
        );
}

/*  Example of usage

void performBasicSearch(String query, int studentId) async {
  // Create the request
  final searchRequest = BasicSearchRequest(query: query, studentId: studentId);

  try {
    // Send the request and await the response
    final response = await searchRequest.send();

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
  performBasicSearch("math", 12345);
}



*/