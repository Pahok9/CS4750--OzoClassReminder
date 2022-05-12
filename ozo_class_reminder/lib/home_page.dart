import 'package:flutter/material.dart';
import 'package:ozo_class_reminder/signup_page.dart';
import 'calendar_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'courses_list_page.dart';
import 'add_class_page.dart';
import 'profile_page.dart';
import 'main.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  final int index;
  final String title;

  MainPage({Key? key, required this.title, required this.index}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState(index);
}

class _MainPageState extends State<MainPage> {
  int _index;
  _MainPageState(this._index);

  final _screens = [
    CalendarPage(),
    CourseListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          backgroundColor: Colors.green,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: _index,
          onDestinationSelected: (_index) =>
            setState(() => this._index = _index),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.calendar_month),
                label: 'Home'
            ),
            NavigationDestination(
                icon: Icon(Icons.format_list_bulleted),
                label: 'List of Courses'
            ),
            NavigationDestination(
                icon: Icon(Icons.account_circle),
                label: 'Profile'
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddClassPage()),
          );
        }
      )
    );
  }
}
