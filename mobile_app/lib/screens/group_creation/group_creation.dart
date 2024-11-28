import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_buds/widgets/custom_filled_button.dart';
import 'package:study_buds/widgets/custom_text_button.dart';
import 'package:dropdown_search/dropdown_search.dart';

class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({Key? key}) : super(key: key);

  @override
  State<GroupCreationScreen> createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController membersLimitController = TextEditingController();
  final TextEditingController telegramLinkController = TextEditingController();
  bool isPrivateGroup = true;

  List<String> courses = [];
  String? selectedCourse;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final url = Uri.parse('http://10.0.2.2:5000/courses/all');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          courses = List<String>.from(responseData['courses']);
        });
      } else {
        print('Error fetching courses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }

  Future<void> createGroup(BuildContext context) async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCourse == null ||
        membersLimitController.text.isEmpty ||
        telegramLinkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: All fields are required.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!telegramLinkController.text.startsWith('https://t.me/')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Telegram link must start with "https://t.me/".'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final membersLimit = int.tryParse(membersLimitController.text);
    if (membersLimit == null || membersLimit < 2 || membersLimit > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Members limit must be between 2 and 100.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final url = Uri.parse('http://10.0.2.2:5000/groups/create');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': nameController.text,
      'description': descriptionController.text,
      'course': selectedCourse,
      'isPublic': !isPrivateGroup,
      'membersLimit': membersLimit,
      'telegramLink': telegramLinkController.text,
      'studentId': 123,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${errorData['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create group. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create a Study Group',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85, // Adjust width dynamically
            constraints: const BoxConstraints(maxWidth: 500), // Set a maximum width
            padding: const EdgeInsets.all(16.0), // Add padding for spacing
            color: Colors.white, // Set the background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Capstone Project',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    filled: true, // Enable the fill color
                    fillColor: Colors.white, // Set the fill color
                    labelStyle: TextStyle(color: Colors.black), // Make the label white for visibility
                  ),
                  style: const TextStyle(color: Colors.black), // Make the text color white
                ),
                const SizedBox(height: 4),
                const Text(
                  'Set a descriptive name for your study group.',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'A study group for people who...',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    fillColor: Colors.white, // Set the fill color
                    labelStyle: TextStyle(color: Colors.black), // Make the label white for visibility
                  ),
                  style: const TextStyle(color: Colors.black), // Make the text color white
                ),
                const SizedBox(height: 4),
                const Text(
                  'Provide details about the goals, topics, or preferences.',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 16),
                DropdownSearch<String>(
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  items: (filter, infiniteScrollProps) => courses,
                  selectedItem: selectedCourse,
                  onChanged: (value) {
                    setState(() {
                      selectedCourse = value;
                    });
                  },
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Course',
                      hintText: 'Select a course',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Choose a course from the list.',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: membersLimitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Members Limit',
                    hintText: '10',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    fillColor: Colors.white, // Set the fill color
                    labelStyle: TextStyle(color: Colors.black), // Make the label white for visibility
                  ),
                  style: const TextStyle(color: Colors.black), // Make the text color white
                ),
                const SizedBox(height: 4),
                const Text(
                  'Limit should be between 2 and 100 members.',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: telegramLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Telegram Group Link',
                    hintText: 'https://t.me/example_group',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    fillColor: Colors.white, // Set the fill color
                    labelStyle: TextStyle(color: Colors.black), // Make the label white for visibility
                  ),
                  style: const TextStyle(color: Colors.black), // Make the text color white
                ),
                const SizedBox(height: 4),
                const Text(
                  'You have to create your Telegram group and add its link here.',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Private Group',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: isPrivateGroup,
                      onChanged: (value) {
                        setState(() {
                          isPrivateGroup = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: CustomFilledButton(
                    label: 'Create the study group',
                    onPressed: () => createGroup(context),
                    iconData: Icons.add,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
