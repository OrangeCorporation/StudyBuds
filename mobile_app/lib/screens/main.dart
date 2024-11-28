import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:study_buds/screens/basic_search/basic_search.dart';
import 'package:study_buds/screens/group_creation/group_creation.dart';
import 'package:study_buds/screens/home/home.dart';
import 'package:study_buds/screens/notification/notification.dart';
import 'package:study_buds/screens/profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BasicSearchPage(title: 'Basic Search'),
    GroupCreationScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        items: const <Widget>[
          Icon(
            Icons.home_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.search_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.group_add_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_rounded,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: _onItemTapped,
        index: _selectedIndex,
        color: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
