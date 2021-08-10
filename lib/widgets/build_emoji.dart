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
        addToFirebase();
      },
      icon: Image.asset(emoji.assetPath),
      iconSize: 100,
    );
  }

  Future addToFirebase() async {
    await DataBaseService().addData(emoji);
  }
}
