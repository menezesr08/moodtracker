import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:how_are_you/models/emoji.dart';
import 'package:how_are_you/services/database.dart';

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
              timestamp: emoji["timestamp"]));
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  // This method does update the listview as soon as you update a list Item, but not a good way.
  void updateResult(Emoji emojiSelected, String docId,
      DataBaseService _databaseService, String timestamp) async {
    _databaseService.updateItem(
        emoji: emojiSelected, docId: docId, timestamp: timestamp);
    setState(() {
      emojis = [];
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _databaseService = DataBaseService(uid: user!.uid);
    return ListView.builder(
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        // Allows deleting an item from listview and from firebase.
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            setState(() {
              _databaseService.deleteItem(docId: emojis[index].id);
              emojis.removeAt(index);
            });
          },
          // Builds listview
          child: Card(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ListTile(
              leading: Image.asset(emojis[index].assetPath),
              title: Text(emojis[index].text,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(emojis[index].timestamp,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])),
              ),
              trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value:
                            Emoji(text: "Great", assetPath: 'assets/great.png'),
                        child: Image.asset('assets/great.png',
                            width: 30, height: 30),
                      ),
                      PopupMenuItem(
                        value:
                            Emoji(text: "Good", assetPath: 'assets/good.png'),
                        child: Image.asset('assets/good.png',
                            width: 30, height: 30),
                      ),
                      PopupMenuItem(
                        value: Emoji(text: "Ok", assetPath: 'assets/ok.png'),
                        child:
                            Image.asset('assets/ok.png', width: 30, height: 30),
                      ),
                      PopupMenuItem(
                          value:
                              Emoji(text: "Bad", assetPath: 'assets/bad.png'),
                          child: Image.asset('assets/bad.png',
                              width: 30, height: 30)),
                      PopupMenuItem(
                          value: Emoji(
                              text: "Awful", assetPath: 'assets/awful.png'),
                          child: Image.asset('assets/awful.png',
                              width: 30, height: 30))
                    ];
                  },
                  // updates result on firebase and the listview
                  onSelected: (Emoji emojiSelected) => updateResult(
                      emojiSelected,
                      emojis[index].id,
                      _databaseService,
                      emojis[index].timestamp)),
            ),
          ),
        );
      },
    );
  }
}
