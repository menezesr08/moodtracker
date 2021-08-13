import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:how_are_you/models/mood.dart';
import 'package:how_are_you/widgets/popupdialog.dart';
import '../services/database.dart';

class BuildMood extends StatelessWidget {
  final Mood mood;

  BuildMood(this.mood);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => PopupDialog(),
        );
        // Adds the selected mood to firebase
        addToFirebase();
      },
      icon: Image.asset(mood.assetPath),
      iconSize: 100,
    );
  }

  Future addToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    await DataBaseService(uid: user!.uid).addItem(mood);
  }
}
