import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';

class Ref {
  static CollectionReference collection(Path path) {
    Object ref = referenceFromPath(path);
    if (ref is CollectionReference) {
      return ref;
    } else {
      Fimber.e("CollectionReference expected but path points to document");
      return null;
    }
  }

  static DocumentReference document(Path path) {
    Object ref = referenceFromPath(path);
    if (ref is DocumentReference) {
      return ref;
    } else {
      Fimber.e("DocumentReference expected but path points to collection");
      return null;
    }
  }

  static Object referenceFromPath(Path path) {
    Object ref = db().collection(path.first());

    for (int i = 1; i < path.size(); i++) {
      String component = path.get(i);

      if (ref is DocumentReference) {
        ref = (ref as DocumentReference).collection(component);
      } else {
        ref = (ref as CollectionReference).document(component);
      }
    }
    return ref;
  }

  static Firestore db() {
    return Firestore.instance;
  }
}
