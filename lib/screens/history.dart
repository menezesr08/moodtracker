import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:how_are_you/services/database.dart';
import 'package:intl/intl.dart';

import '../models/emoji_row.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final user = FirebaseAuth.instance.currentUser;
  List<EmojiRow> emojis = [];
  // Retrieve data from firebase based on user id.
  Future<dynamic> getData() async {
    FirebaseFirestore.instance
        .collection('userData')
        .doc(user!.uid)
        .collection("mood")
        .orderBy("timestamp")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((emoji) {
        setState(() {
          emojis.add(EmojiRow(
              id: emoji.id,
              text: emoji["text"],
              assetPath: emoji["assetPath"],
              timestamp: convertEpochToString(emoji["timestamp"])));
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        // Allows deleting an item from listview and from firebase.
        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                DataBaseService(uid: user!.uid).deleteItem(docId: emojis[index].id);
                emojis.removeAt(index);
              });
            },
            // Builds listview
            child: RowTemplate(emojis[index]));
      },
    );
  }
}

// Template for each row in the listview
class RowTemplate extends StatelessWidget {
  final EmojiRow emojiRow;

  RowTemplate(this.emojiRow);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          Text(emojiRow.text,
              style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          SizedBox(width: 10),
          Image.asset(emojiRow.assetPath, height: 30, width: 30),
          SizedBox(width: 40),
          Text(emojiRow.timestamp,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// converts a given timestamp to string format
String convertEpochToString(var timestamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('dd/MM/yyyy, HH:mm').format(dt);
}
