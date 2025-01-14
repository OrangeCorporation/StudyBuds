import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/telegram/telegram_bot.dart';
import 'package:study_buds/utils/auth_utils.dart';

import '../../blocs/profile/bloc/profile_bloc.dart';
import '../../models/student.dart';
import '../../widgets/custom_filled_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? telegramAccountId;
  Student? student;
  late TextEditingController telegramController;

  @override
  void initState() {
    super.initState();
    telegramController = TextEditingController();
  }

  @override
  void dispose() {
    telegramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocProvider(
        create: (_) => ProfileBloc()..add(FetchProfileDetailsEvent()),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              setState(() {
                student = state.student;
                telegramController.text = student!.telegramId.toString();
              });
            }
            if (state is ProfileSaveSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: Colors.green),
              );
            } else if (state is ProfileSaveFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (student == null) {
              return const Center(child: Text('No profile data available.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            key: ValueKey('full_name_text_field'),
                            controller: TextEditingController(
                                text:
                                    '${student!.firstName} ${student!.lastName}'),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            key: ValueKey('student_id_text_field'),
                            controller: TextEditingController(
                                text: student!.id.toString()),
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Student ID',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            key: ValueKey('telegram_account_id_text_field'),
                            controller: telegramController,
                            decoration: InputDecoration(
                              labelText: 'Telegram Account ID',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.white,
                              helperText:
                                  'Use the bot below to get your Telegram ID.',
                            ),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                telegramAccountId = value;
                              });
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                          const SizedBox(height: 10),
                            Center(
                              child: TextButton.icon(
                                onPressed: TelegramBot.launchTelegramBot,
                                icon: const Icon(Icons.telegram),
                                label: const Text('Get Telegram ID via Bot'),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (telegramAccountId != null) {
                          context
                              .read<ProfileBloc>()
                              .add(SaveProfileDetailsEvent(
                                int.parse(telegramAccountId!),
                              ));
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save the changes'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, // Ensure the button takes full width
                    child: CustomFilledButton(
                      key: const Key('logout_button'),
                      isEnabled: true,
                      label: 'Logout',
                      backgroundColor: Colors.red, // Red background for "Logout"
                      foregroundColor: Colors.white, // Light text for contrast
                      onPressed: () {
                       // AuthUtils.logout(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                key: const Key('logout_confirmation_dialog'),
                                title: const Text('Confirm Logout'),
                              content: const Text('Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  key: const Key('cancel_button'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  key: const Key('confirm_logout'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                    AuthUtils.logout(context); // Perform logout
                                  },
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text('Logout'),
                                ),
                              ]
                            );
                          }
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
