import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BasicSearch(),
    );
  }
}

class BasicSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search a study group"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Text(
                'ciao',
                style: TextStyle(
                  fontSize: 24, // Adjust font size as desired
                  fontWeight: FontWeight.bold, // Make it bold if desired
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
