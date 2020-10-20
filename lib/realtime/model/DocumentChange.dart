import 'package:firebase_database/firebase_database.dart';

enum EventType {
  Added,
  Removed,
  Modified,
}

class DocumentChange {
  DataSnapshot snapshot;
  EventType type;

  DocumentChange(this.snapshot, {this.type});

  DataSnapshot getSnapshot() {
    return snapshot;
  }

  EventType getType() {
    return type;
  }
}
