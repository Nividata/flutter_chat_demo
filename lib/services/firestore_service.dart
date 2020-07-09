import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseDbService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Stream<void> authenticate(Map<String, dynamic> data, AuthResult authResult) {
    print("ok im here");
    return Stream.fromFuture(_firebaseDatabase
        .reference()
        .child("users")
        .child(authResult.user.uid)
        .update(data));
  }
}
