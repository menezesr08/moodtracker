import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:how_are_you/models/mood.dart';
import 'package:intl/intl.dart';

class DataBaseService {
  final String? uid;
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection("userData");

  DataBaseService({this.uid});

  Future addItem(Mood mood) async {
    Map<String, dynamic> currentMood = <String, dynamic>{
      "text": mood.text,
      "assetPath": mood.assetPath,
      "timestamp": FieldValue.serverTimestamp(),
      "type": mood.type
    };

    return userDataCollection.doc(uid).collection("mood").add(currentMood);
  }

  Future<void> deleteItem({required String docId}) {
    return userDataCollection.doc(uid).collection('mood').doc(docId).delete();
  }

  Future<void> updateItem(
      {required Mood mood, required String docId, required Timestamp timestamp}) {
    Map<String, dynamic> newMood = <String, dynamic>{
      "text": mood.text,
      "assetPath": mood.assetPath,
      "timestamp": timestamp
    };
    return userDataCollection
        .doc(uid)
        .collection('mood')
        .doc(docId)
        .update(newMood);
  }

  // converts a given timestamp to string format
  String convertEpochToString(var timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy, HH:mm').format(dt);
  }
}
