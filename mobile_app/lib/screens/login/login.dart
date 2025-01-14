import 'package:flutter/material.dart';
import 'package:study_buds/utils/auth_utils.dart';
import 'package:study_buds/utils/push_notification.dart';

class Login extends StatelessWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        label: const Text("English"),
                        icon: const Icon(Icons.language_rounded),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        label: const Text("Dark mode"),
                        icon: const Icon(Icons.dark_mode_rounded),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: const Image(
                          image: AssetImage("assets/images/logo_dark.png"),
                          width: 164,
                          height: 164,
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 64),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello Student!",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "This platform is made only for University of Genoa student. Use your UniGe username and password to login. Otherwise you can see the limited features as a guest.",
                          style: TextStyle(fontSize: 14),
                        ),
                        Image(
                          image: AssetImage('assets/images/unige_logo.webp'),
                          width: 112,
                          height: 112,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        key: const Key('login_button'),
                        onPressed: () => {
                            AuthUtils.authenticateWithUnige(context),
                            PushNotificationService.instance.retrievePushNotificationToken()
                        },
                        icon: const Icon(
                          Icons.person_rounded,
                          size: 18,
                        ),
                        label: const Text("Login using UniGe credentials"),
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6.0), // Adjust the radius as needed
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 25, // Adjust the width as needed
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Text(
                            "OR",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 25, // Adjust the width as needed
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        key: const Key('guest_button'),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        label: const Text("Continue as a guest"),
                        icon: const Icon(Icons.login_rounded),
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary,
                          ),
                          iconColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "By using the application, you agree to the ",
                              style: TextStyle(fontSize: 12),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              textColor:
                                  Theme.of(context).colorScheme.secondary,
                              child: const Text(
                                "Privacy Policy",
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
