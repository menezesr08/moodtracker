// Object which defines each row in the listview
class EmojiRow {
  String text;
  String assetPath;
  var timestamp;
  String id;

  // id - id returned from Firebase
  EmojiRow(
      {required this.id,
      required this.text,
      required this.assetPath,
      required this.timestamp});
}
