import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:how_are_you/models/emoji.dart';
import 'package:how_are_you/widgets/popupdialog.dart';
import '../services/database.dart';

class BuildEmoji extends StatelessWidget {
  final Emoji emoji;

  BuildEmoji(this.emoji);

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
      icon: Image.asset(emoji.assetPath),
      iconSize: 100,
    );
  }

  Future addToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    await DataBaseService(uid: user!.uid).addItem(emoji);
  }
}
