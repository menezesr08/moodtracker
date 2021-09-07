import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:how_are_you/models/mood.dart';
import 'package:how_are_you/services/database.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/db_mood.dart';
import '../enums/mood_enum.dart';

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

  @override
  Widget build(BuildContext context) {
    final _databaseService = DataBaseService(uid: currentUser!.uid);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            body: Column(
              children: <Widget>[
                ColoredBox(
                  color: Colors.redAccent,
                  child: TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.list), text: 'List'),
                      Tab(icon: Icon(Icons.auto_graph), text: 'Graph')
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: StreamBuilder(
                      stream: currentUserMoodRef,
                      builder:
                          (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData) return new Text('Loading...');
                        dbMoods.clear();
                        snapshot.data!.docs.forEach((
                            QueryDocumentSnapshot doc) {
                          dbMoods.add(DbMood(
                              id: doc.id,
                              text: doc.get("text"),
                              assetPath: doc.get("assetPath"),
                              timestamp: doc.get("timestamp"),
                              type: doc.get("type")));
                        });

                        return TabBarView(children: [
                          HistoryListview(
                              dbMoods: dbMoods,
                              databaseService: _databaseService),
                          PointsLineChart(dbMoods, animate: false)
                        ]);
                      },
                    )
                  // child: TabBarView(
                  //   children: [
                  //     HistoryListview(currentUserMoodRef: currentUserMoodRef, dbMoods: dbMoods, databaseService: _databaseService),
                  //     PointsLineChart.withSampleData()
                  //   ],
                  // ),
                )
              ],
            )),
      ),
    );
  }
}

class HistoryListview extends StatefulWidget {
  const HistoryListview({
    Key? key,
    required this.dbMoods,
    required DataBaseService databaseService,
  })
      : _databaseService = databaseService,
        super(key: key);

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
        body: ListView.builder(
          itemCount: widget.dbMoods.length,
          itemBuilder: (context, index) {
            // Allows deleting an item from listview and from firebase.
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                widget._databaseService
                    .deleteItem(docId: widget.dbMoods[index].id);
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
                    child: Text(formatDate(widget.dbMoods[index].timestamp),
                        style:
                        TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ),
                  trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: Mood(
                                text: "Great",
                                assetPath: 'assets/great.png',
                                type: MoodEnum.great.index),
                            child: Image.asset('assets/great.png',
                                width: 30, height: 30),
                          ),
                          PopupMenuItem(
                            value: Mood(
                                text: "Good",
                                assetPath: 'assets/good.png',
                                type: MoodEnum.good.index),
                            child: Image.asset('assets/good.png',
                                width: 30, height: 30),
                          ),
                          PopupMenuItem(
                            value: Mood(
                                text: "Ok",
                                assetPath: 'assets/ok.png',
                                type: MoodEnum.ok.index),
                            child: Image.asset('assets/ok.png',
                                width: 30, height: 30),
                          ),
                          PopupMenuItem(
                              value: Mood(
                                  text: "Bad",
                                  assetPath: 'assets/bad.png',
                                  type: MoodEnum.bad.index),
                              child: Image.asset('assets/bad.png',
                                  width: 30, height: 30)),
                          PopupMenuItem(
                              value: Mood(
                                  text: "Awful",
                                  assetPath: 'assets/awful.png',
                                  type: MoodEnum.awful.index),
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
        ));
  }

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat.yMMMd().add_jm().format(date);
  }
}
// Todo: Y axis needs images as ticks to represent moods. Can't find the functionality in any graphs library
class PointsLineChart extends StatefulWidget {
  final bool animate;
  final List<DbMood> dbMoods;

  PointsLineChart(this.dbMoods, {required this.animate});

  @override
  _PointsLineChartState createState() => _PointsLineChartState();
}

class _PointsLineChartState extends State<PointsLineChart> {
  late List<TimeSeriesMood> timeSeriesList;

  @override
  void initState() {
    timeSeriesList = widget.dbMoods.map((e) =>
    new TimeSeriesMood(formatDate(e.timestamp), e.type)).toList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                  // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        minimum: -1,
                        maximum: 5,
                        interval: 1
                    ),
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        // Templating the legend item
                        legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
                          return Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('0 - Great'),
                                    Text('1 - Good'),
                                    Text('2 - Ok'),
                                    Text('3 - Bad'),
                                    Text('4 - Awful')
                                  ]
                              )
                          );
                        }
                    ),
                    series: <ChartSeries>[
                      // Initialize line series
                      ScatterSeries<TimeSeriesMood, String>(
                          dataSource: timeSeriesList,
                          xValueMapper: (TimeSeriesMood timeSeries, _) => timeSeries.time,
                          yValueMapper: (TimeSeriesMood timeSeries, _) => timeSeries.mood,
                          markerSettings: MarkerSettings(
                              height: 15,
                              width: 15,
                              // Scatter will render in diamond shape
                              shape: DataMarkerType.diamond
                          )
                      )
                    ]
                )
            )
        )
    );
  }
  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat.MMMd().format(date);
  }

}

/// Sample linear data type.
class TimeSeriesMood {
  final String time;
  final int mood;

  TimeSeriesMood(this.time, this.mood);
}
