import 'package:flutter/material.dart';
import 'package:how_are_you/screens/history.dart';
import 'package:how_are_you/screens/select_mood.dart';
import 'package:how_are_you/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Mood Tracker"),
            centerTitle: true,
            backgroundColor: Colors.red[500],
            actions: <Widget>[
              TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(Icons.person),
                  label: Text('logout'))
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.emoji_emotions),
                  text: 'Mood',
                ),
                Tab(icon: Icon(Icons.history), text: 'History')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SelectMood(),
              History() // History()
            ],
          )),
    );
  }
}
