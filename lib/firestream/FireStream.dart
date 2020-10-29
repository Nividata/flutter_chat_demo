import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseService.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/firestream/Chat/Message.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';

class FireStream {
  static final FireStream _instance = FireStream._internal();
  FirebaseUser firebaseUser;
  FirebaseService firebaseService;

  factory FireStream() {
    return _instance;
  }

  FireStream._internal() {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseAuth) {
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

  Stream<List<User>> getAllUserList() {
    return getFirebaseService()
        .core
        .getAllUserList(Paths.usersPath(), firebaseUser.uid);
  }

  Stream<List<Thread>> getAllActiveChatUserList() {
    return getFirebaseService()
        .core
        .getAllActiveChatUserList(Paths.chatsPath());
  }

  Stream<Thread> createThreadByUser(User otherUser) {
    return getFirebaseService()
        .chat
        .createThreadByUser(otherUser, firebaseUser.uid);
  }

  Stream<Message> listenOnChat(Thread threads) {
    return getFirebaseService().chat.listenOnChat(
        Paths.chatMessagesPath(threads.id), threads, firebaseUser.uid);
  }

  Stream<Message> sendMessage(Thread threads, Message message) {
    return getFirebaseService().chat.sendMessage(
        Paths.chatMessagesPath(threads.id),
        threads,
        message,
        firebaseUser.uid);
  }

  String currentUserId() {
    return firebaseUser.uid;
  }

  Map<String, String> timestamp() {
    return getFirebaseService().core.timestamp();
  }
}
