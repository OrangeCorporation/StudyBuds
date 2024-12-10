import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/models/profile.dart';
import 'package:study_buds/telegram/telegram_bot.dart';

import '../../blocs/profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController telegramController = TextEditingController();
  Profile? profile; // Use nullable type

  @override
  void initState() {
    super.initState();
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
        create: (_) => ProfileBloc()..add(FetchProfileDetailsEvent(10)),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              setState(() {
                profile = state.profile; // Assign profile when data is loaded
              });
            }
            if (state is ProfileSaveSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
              );
            } else if (state is ProfileSaveFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (profile == null) {
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
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '${profile!.firstName} ${profile!.lastName}',
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Student ID',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: profile!.studentId.toString(),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: telegramController,
                            decoration: InputDecoration(
                              labelText: 'Telegram Account ID',
                              hintText: profile!.telegramAccount.toString(),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.white,
                              helperText: 'Use the bot below to get your Telegram ID.',
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          if (profile?.telegramAccount == null)
                            Center(
                              child: TextButton.icon(
                                onPressed: TelegramBot.launchTelegramBot,
                                icon: const Icon(Icons.telegram),
                                label: const Text('Get Telegram ID via Bot'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).primaryColor,
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
                        if (telegramController.text.isNotEmpty) {
                          context.read<ProfileBloc>().add(SaveProfileDetailsEvent(
                            10, int.parse(telegramController.text),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}