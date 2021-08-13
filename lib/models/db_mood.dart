// Object which defines each row in the listview
class DbMood {
  String text;
  String assetPath;
  String timestamp;
  String id;

  // id - id returned from Firebase
  DbMood(
      {required this.id,
      required this.text,
      required this.assetPath,
      required this.timestamp});
}
