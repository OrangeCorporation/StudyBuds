import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/group_creation/bloc/group_creation_bloc.dart';
import '../../models/group.dart';
import '../../widgets/custom_filled_button.dart';

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
  String selectedCourse = '';

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
        body: BlocProvider(
          create: (_) => GroupCreationBloc()..add(FetchCoursesListEvent()),
          child: Scaffold(
            body: BlocConsumer<GroupCreationBloc, GroupCreationState>(
              listener: (context, state) {
                if (state is GroupCreationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                          state.message,
                          key: Key('success_snackbar'),
                        ),
                        backgroundColor: Colors.green),
                  );
                } else if (state is GroupCreationFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.error, key: Key('error_snackbar')),
                        backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                          key: Key('loading_indicator')));
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Capstone Project',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          key: Key('group_name_field'),
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            fillColor: Colors.white,
                            // Set the fill color
                            labelStyle: TextStyle(
                                color: Colors
                                    .black), // Make the label white for visibility
                          ),
                          style: const TextStyle(color: Colors.black),
                          // Make t
                          key: Key(
                              'group_description_field'), // he text color white
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Provide details about the goals, topics, or preferences.',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        DropdownSearch<String>(
                          items: (filter, loadProps) => state.courses,
                          // items: state.courses,
                          selectedItem: selectedCourse,
                          onChanged: (value) {
                            selectedCourse = value!;
                          },
                          key: Key('course_dropdown_field'),
                          decoratorProps: const DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: 'Course',
                              hintText: 'Select a course',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                          decoration: InputDecoration(
                            labelText: 'Members Limit',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          style: const TextStyle(color: Colors.black),
                          //
                          key: Key('members_limit_field'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Limit should be between 2 and 100 members.',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: telegramLinkController,
                          decoration: InputDecoration(
                            labelText: 'Telegram Group Link',
                            hintText: 'https://t.me/example_group',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            fillColor: Colors.white,
                            // Set the fill color
                            labelStyle: TextStyle(
                                color: Colors
                                    .black), // Make the label white for visibility
                          ),
                          key: Key('telegram_group_link_field'),
                          style: const TextStyle(
                              color: Colors.black), // Make the text color white
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
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            Switch(
                              value: isPrivateGroup,
                              key: Key('is_private_group_switch'),
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
                            key: Key('create_group_button'),
                            iconData: Icons.add,
                            onPressed: () {
                              context
                                  .read<GroupCreationBloc>()
                                  .add(CreateGroupEvent(
                                    Group(
                                        name: nameController.text,
                                        description: descriptionController.text,
                                        course: selectedCourse,
                                        membersLimit: membersLimitController
                                            .text.isNotEmpty
                                            ? int.parse(
                                            membersLimitController.text)
                                            : 2,
                                        members: [],
                                        telegramLink:
                                            telegramLinkController.text,
                                        isPublic: !isPrivateGroup,
                                        ownerId: 10),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
