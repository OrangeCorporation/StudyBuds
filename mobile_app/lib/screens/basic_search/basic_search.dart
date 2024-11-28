import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:study_buds/widgets/group_card.dart'; // Import GroupCard
import 'package:study_buds/models/group.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BasicSearchPage(title: "heyy"),
    );
  }
}

class BasicSearchPage extends StatefulWidget {
  const BasicSearchPage({super.key, required this.title});
  final String title;

  @override
  State<BasicSearchPage> createState() => _BasicSearchState();
}

class _BasicSearchState extends State<BasicSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Group> _searchResults = []; // Store Group objects

  // Perform an API call when the user presses Enter
  Future<void> _performSearch(String query) async {
    final url =
        Uri.parse('http://10.0.2.2:5000/groups/basic_search/adm/6139355');
    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Map the dynamic response to a list of Group objects
        setState(() {
          _searchResults = List<Group>.from(data.map((item) {
            var gr = Group.fromJson(item);
            print(";;;");
            print(gr.isPublic);
            print(";;;");
            return gr; // Return the Group object so it's added to the list
          }));
        });
        print('_searchResults: $_searchResults'); // Print the search results
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search for a study group',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (String query) {
                _performSearch(
                    query); // Trigger the API call when Enter is pressed
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final group = _searchResults[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GroupCard(
                          group:
                              group), // Use the GroupCard widget to display each group
                      Divider(), // Add a divider for better separation
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
