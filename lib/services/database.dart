import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:how_are_you/models/emoji.dart';

class DataBaseService {
  final CollectionReference emojis =
      FirebaseFirestore.instance.collection("emojis");

  Future addData(Emoji emoji) async {
    Map<String, dynamic> data = <String, dynamic>{
      "text": emoji.text,
      "assetPath": emoji.assetPath,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    DocumentReference ref = await emojis.add(data);
    return ref;
  }
}
