import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:how_are_you/screens/history.dart';
import 'package:how_are_you/screens/select_mood.dart';
import 'package:how_are_you/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex = 0;
  final List<Widget> _children =  [SelectMood(), History()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mood Tracker"),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('logout'))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 20,
          selectedIconTheme: IconThemeData(color: Colors.black, size: 20),
          selectedItemColor: Colors.black,
          backgroundColor: Colors.redAccent,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_emotions), label: 'Mood'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History')
          ],
        ),
        body: _children[_currentIndex]);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
