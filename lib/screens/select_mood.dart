import 'package:flutter/material.dart';
import 'package:how_are_you/models/mood.dart';
import 'package:how_are_you/widgets/build_mood.dart';

class SelectMood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              child: BuildMood(
                  new Mood(text: "Great", assetPath: 'assets/great.png'))),
          Container(
              child: BuildMood(new Mood(
            text: "Good",
            assetPath: 'assets/good.png',
          ))),
          Container(
              child: BuildMood(new Mood(
            text: "Ok",
            assetPath: 'assets/ok.png',
          ))),
          Container(
              child: BuildMood(new Mood(
            text: "Bad",
            assetPath: 'assets/bad.png',
          ))),
          Container(
              child: BuildMood(new Mood(
            text: "Awful",
            assetPath: 'assets/awful.png',
          ))),
        ],
      ),
    );
  }
}
