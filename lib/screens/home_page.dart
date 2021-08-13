import 'package:flutter/material.dart';
import 'package:how_are_you/screens/history.dart';
import 'package:how_are_you/services/auth.dart';
import '../widgets/build_emoji.dart';
import '../models/emoji.dart';

class MyHomePage extends StatelessWidget {
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
              SingleChildScrollView(
                // This is the screen where user can select the mood
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'How are you?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.blue[800]),
                      ),
                    ),
                    Container(
                        child: BuildEmoji(new Emoji(
                            text: "Great", assetPath: 'assets/great.png'))),
                    Container(
                        child: BuildEmoji(new Emoji(
                      text: "Good",
                      assetPath: 'assets/good.png',
                    ))),
                    Container(
                        child: BuildEmoji(new Emoji(
                      text: "Ok",
                      assetPath: 'assets/ok.png',
                    ))),
                    Container(
                        child: BuildEmoji(new Emoji(
                      text: "Bad",
                      assetPath: 'assets/bad.png',
                    ))),
                    Container(
                        child: BuildEmoji(new Emoji(
                      text: "Awful",
                      assetPath: 'assets/awful.png',
                    ))),
                  ],
                ),
              ),
              //This is the other screen which shows the historic moods.
              History() // History()
            ],
          )),
    );
  }
}
