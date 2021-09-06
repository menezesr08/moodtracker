// Object which defines each row in the listview
import 'package:cloud_firestore/cloud_firestore.dart';

class DbMood {
  String text;
  String assetPath;
  Timestamp timestamp;
  String id;
  int type;

  // id - id returned from Firebase
  DbMood(
      {required this.id,
      required this.text,
      required this.assetPath,
      required this.timestamp,
      required this.type});
}
