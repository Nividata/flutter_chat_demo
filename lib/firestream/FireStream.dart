import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseService.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';

class FireStream {
  static final FireStream _instance = FireStream._internal();
  FirebaseUser firebaseUser;
  FirebaseService firebaseService;

  factory FireStream() {
    return _instance;
  }

  FireStream._internal() {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseAuth) {
      print(firebaseAuth.uid);
      if (this.firebaseUser == null && firebaseAuth != null) {
        this.firebaseUser = firebaseAuth;
      }
      if (this.firebaseUser != null && firebaseAuth == null) {
        this.firebaseUser = null;
      }
    });
  }

  static FireStream shared() {
    return _instance;
  }

  void initialize(FirebaseService service) {
    firebaseService = service;
  }

  FirebaseService getFirebaseService() {
    return firebaseService;
  }

  Stream<void> addUsers(User user) {
    return getFirebaseService().core.addUsers(Paths.userPath(), user);
  }

  Stream<List<UserKey>> getAllUserList() {
    return getFirebaseService().core.getAllUserList(Paths.usersPath());
  }

  Stream<List<ThreadKey>> getAllActiveChatUserList() {
    return getFirebaseService()
        .core
        .getAllActiveChatUserList(Paths.chatsPath());
  }

  String currentUserId() {
    return firebaseUser.uid;
  }
}
