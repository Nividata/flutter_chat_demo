
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseDbService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Stream<void> saveUser(Map<String, dynamic> data) {
    print("ok im here");
    return Stream.fromFuture(
        _firebaseDatabase.reference().child("users").push().set(data));
  }
}
