import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:how_are_you/models/emoji.dart';
import 'package:intl/intl.dart';

class DataBaseService {
  final String? uid;
  final CollectionReference emojisCollection =
      FirebaseFirestore.instance.collection("userData");

  DataBaseService({this.uid});

  Future addItem(Emoji emoji) async {
    Map<String, dynamic> currentEmoji = <String, dynamic>{
      "text": emoji.text,
      "assetPath": emoji.assetPath,
      "timestamp": convertEpochToString(DateTime.now().millisecondsSinceEpoch)
    };

    return emojisCollection.doc(uid).collection("mood").add(currentEmoji);
  }

  Future<void> deleteItem({required String docId})  {
    return emojisCollection.doc(uid).collection('mood').doc(docId).delete();
  }

  Future<void> updateItem({ required Emoji emoji, required String docId, required String timestamp})  {
    Map<String, dynamic> data = <String, dynamic>{
      "text": emoji.text,
      "assetPath": emoji.assetPath,
      "timestamp": timestamp
    };
    return emojisCollection.doc(uid).collection('mood').doc(docId).update(data);
  }

  // converts a given timestamp to string format
  String convertEpochToString(var timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy, HH:mm').format(dt);
  }

}
