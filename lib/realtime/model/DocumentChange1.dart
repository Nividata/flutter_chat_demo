import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

enum EventType {
  Added,
  Removed,
  Modified,
}

class DocumentChange1 {
  DataSnapshot snapshot;
  EventType type;

  DocumentChange1(this.snapshot, {this.type});

  DataSnapshot getSnapshot() {
    return snapshot;
  }

  EventType getType() {
    return type;
  }
}

class DocumentChange2 {
  DocumentSnapshot snapshot;
  EventType type;

  DocumentChange2(this.snapshot, {this.type});

  DocumentSnapshot getSnapshot() {
    return snapshot;
  }

  EventType getType() {
    return type;
  }
}
