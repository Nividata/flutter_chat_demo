import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/transformers.dart';
import 'package:tuple/tuple.dart';

@lazySingleton
class FirebaseDbService {
  AuthenticationService _authenticationService;

  FirebaseDbService(this._authenticationService);

  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Stream<void> authenticate(Map<String, dynamic> data) {
    print("ok im here");
    return Stream.fromFuture(_authenticationService.currentUser()).transform(
        FlatMapStreamTransformer((FirebaseUser user) => Stream.fromFuture(
            _firebaseDatabase
                .reference()
                .child("users")
                .child(user.uid)
                .update(data))));
  }

  Stream<String> createMessageThread() {
    return Stream.fromFuture(_authenticationService.currentUser())
        .transform(FlatMapStreamTransformer((FirebaseUser user) => Stream.value(
            Tuple2(
                user.uid,
                _firebaseDatabase
                    .reference()
                    .child("users")
                    .child(user.uid)
                    .child("message")
                    .push()
                    .key))))
        .flatMap((Tuple2 tuple2) => ZipStream([
              Stream.fromFuture(_firebaseDatabase
                  .reference()
                  .child("users")
                  .child(tuple2.item1)
                  .child("message")
                  .child(tuple2.item2)
                  .update({"user": "user"})),
              Stream.fromFuture(_firebaseDatabase
                  .reference()
                  .child("threads")
                  .child(tuple2.item2)
                  .update({"owner": "${tuple2.item1}"})),
            ], (List<void> b) => b.length.toString()));
  }

/* Stream<DataSnapshot> getMessage() {
    return Stream.fromFuture(_authenticationService.currentUser())
        .transform(FlatMapStreamTransformer((FirebaseUser user) =>
            Stream.fromFuture(_firebaseDatabase
                .reference()
                .child("users")
                .child(user.uid)
                .child("message")
                .once())))
        .transform(FlatMapStreamTransformer((DataSnapshot snapshot) {
      if (snapshot == null)
        return createMessageThread();
      else
        Stream.value(snapshot);
    }));
  }*/
}
