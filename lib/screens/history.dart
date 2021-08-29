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
        .collection("mood")
        .orderBy("timestamp")
        .snapshots();
  }

  // @override
  // Widget build(BuildContext context) {
  //   final _databaseService = DataBaseService(uid: currentUser!.uid);
  //   return HistoryListview(currentUserMoodRef: currentUserMoodRef, dbMoods: dbMoods, databaseService: _databaseService);
  // }
  @override
  Widget build(BuildContext context) {
    final _databaseService = DataBaseService(uid: currentUser!.uid);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            body:
            Column(
              children: <Widget>[
                ColoredBox(
                  color:  Colors.red,
                  child: TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.list), text: 'List'),
                      Tab(icon: Icon(Icons.auto_graph), text: 'Graph')
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TabBarView(
                    children: [
                      HistoryListview(currentUserMoodRef: currentUserMoodRef, dbMoods: dbMoods, databaseService: _databaseService),
                      HistoryGraph()
                    ],
                  ),
                )
              ],
            )

        ),
      ),
    );
  }
}

class HistoryListview extends StatefulWidget {
  const HistoryListview({
    Key? key,
    required this.currentUserMoodRef,
    required this.dbMoods,
    required DataBaseService databaseService,
  }) : _databaseService = databaseService, super(key: key);

  final currentUserMoodRef;
  final List<DbMood> dbMoods;
  final DataBaseService _databaseService;

  @override
  _HistoryListviewState createState() => _HistoryListviewState();
}

class _HistoryListviewState extends State<HistoryListview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // listens to the current users data and checks automatically for any updates
      body: StreamBuilder(
        stream: widget.currentUserMoodRef,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          widget.dbMoods.clear();
          snapshot.data!.docs.forEach((QueryDocumentSnapshot doc) {
            widget.dbMoods.add(DbMood(
                id: doc.id,
                text: doc.get("text"),
                assetPath: doc.get("assetPath"),
                timestamp: doc.get("timestamp")));
          });
          return ListView.builder(
            itemCount: widget.dbMoods.length,
            itemBuilder: (context, index) {
              // Allows deleting an item from listview and from firebase.
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  widget._databaseService.deleteItem(docId: widget.dbMoods[index].id);
                  widget.dbMoods.removeAt(index);
                },
                // Builds listview
                child: Card(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ListTile(
                    leading: Image.asset(widget.dbMoods[index].assetPath),
                    title: Text(widget.dbMoods[index].text,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(widget.dbMoods[index].timestamp,
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
                            widget._databaseService.updateItem(
                                mood: moodSelected,
                                docId: widget.dbMoods[index].id,
                                timestamp: widget.dbMoods[index].timestamp)),
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

class HistoryGraph extends StatefulWidget {
  @override
  _HistoryGraphState createState() => _HistoryGraphState();
}

class _HistoryGraphState extends State<HistoryGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Graph")
    );
  }
}

