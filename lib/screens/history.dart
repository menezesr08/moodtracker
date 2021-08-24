import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:how_are_you/models/mood.dart';
import 'package:how_are_you/services/database.dart';

import '../models/db_mood.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final currentUser = FirebaseAuth.instance.currentUser;
  var currentUserMoodRef;
  List<DbMood> dbMoods = [];

  @override
  void initState() {
    super.initState();
    // point to the data in firebase for the current user
    currentUserMoodRef = FirebaseFirestore.instance
        .collection('userData')
        .doc(currentUser!.uid)
        .collection("mood").orderBy("timestamp")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final _databaseService = DataBaseService(uid: currentUser!.uid);
    return Scaffold(
      // listens to the current users data and checks automatically for any updates
      body: StreamBuilder(
        stream: currentUserMoodRef,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          dbMoods.clear();
          snapshot.data!.docs.forEach((QueryDocumentSnapshot doc) {
            dbMoods.add(DbMood(
                id: doc.id,
                text: doc.get("text"),
                assetPath: doc.get("assetPath"),
                timestamp: doc.get("timestamp")));
          });
          return ListView.builder(
            itemCount: dbMoods.length,
            itemBuilder: (context, index) {
              // Allows deleting an item from listview and from firebase.
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  _databaseService.deleteItem(docId: dbMoods[index].id);
                  dbMoods.removeAt(index);
                },
                // Builds listview
                child: Card(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ListTile(
                    leading: Image.asset(dbMoods[index].assetPath),
                    title: Text(dbMoods[index].text,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(dbMoods[index].timestamp,
                          style:
                          TextStyle(fontSize: 18, color: Colors.grey[600])),
                    ),
                    trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: Mood(
                                  text: "Great", assetPath: 'assets/great.png'),
                              child: Image.asset('assets/great.png',
                                  width: 30, height: 30),
                            ),
                            PopupMenuItem(
                              value: Mood(
                                  text: "Good", assetPath: 'assets/good.png'),
                              child: Image.asset('assets/good.png',
                                  width: 30, height: 30),
                            ),
                            PopupMenuItem(
                              value:
                              Mood(text: "Ok", assetPath: 'assets/ok.png'),
                              child: Image.asset('assets/ok.png',
                                  width: 30, height: 30),
                            ),
                            PopupMenuItem(
                                value: Mood(
                                    text: "Bad", assetPath: 'assets/bad.png'),
                                child: Image.asset('assets/bad.png',
                                    width: 30, height: 30)),
                            PopupMenuItem(
                                value: Mood(
                                    text: "Awful",
                                    assetPath: 'assets/awful.png'),
                                child: Image.asset('assets/awful.png',
                                    width: 30, height: 30))
                          ];
                        },
                        // updates firebase when user updates mood
                        onSelected: (Mood moodSelected) =>
                            _databaseService.updateItem(mood: moodSelected,
                                docId: dbMoods[index].id,
                                timestamp: dbMoods[index].timestamp)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}