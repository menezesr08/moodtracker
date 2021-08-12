import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:how_are_you/models/emoji.dart';

class DataBaseService {
  final String? uid;
  final CollectionReference emojisCollection =
      FirebaseFirestore.instance.collection("userData");

  DataBaseService({this.uid});

  Future addItem(Emoji emoji) async {
    Map<String, dynamic> currentEmoji = <String, dynamic>{
      "text": emoji.text,
      "assetPath": emoji.assetPath,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    return emojisCollection.doc(uid).collection("mood").add(currentEmoji);
  }

  Future<void> deleteItem({required String docId})  {
    return emojisCollection.doc(uid).collection('mood').doc(docId).delete();
  }
}
