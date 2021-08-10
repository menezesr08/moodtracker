import 'package:flutter/material.dart';
import 'package:how_are_you/screens/history_card.dart';
import '../widgets/build_emoji.dart';
import '../models/emoji.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Mood Tracker"),
            centerTitle: true,
            backgroundColor: Colors.red[500],
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
              Column(
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
                          text: "great", assetPath: 'assets/great.png'))),
                  Container(
                      child: BuildEmoji(new Emoji(
                    text: "good",
                    assetPath: 'assets/good.png',
                  ))),
                  Container(
                      child: BuildEmoji(new Emoji(
                    text: "ok",
                    assetPath: 'assets/ok.png',
                  ))),
                  Container(
                      child: BuildEmoji(new Emoji(
                    text: "bad",
                    assetPath: 'assets/bad.png',
                  ))),
                  Container(
                      child: BuildEmoji(new Emoji(
                    text: "awful",
                    assetPath: 'assets/awful.png',
                  ))),
                ],
              ),
              History()
            ],
          )),
    );
  }
}
