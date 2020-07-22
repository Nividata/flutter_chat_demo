import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';

class Ref {
  static DatabaseReference get(Path path) {
    return db().reference().child(path.toString());
  }

  static FirebaseDatabase db() {
    return FirebaseDatabase.instance;
  }
}
