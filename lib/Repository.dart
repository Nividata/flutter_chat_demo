import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';

import 'models/response/Message.dart';
import 'models/response/Threads.dart';

abstract class Repository {
  Stream<void> authenticate(Map<String, dynamic> data);

  Stream<FirebaseUser> currentUser();

  Stream<UserKey> currentUserData();

  Stream<List<ThreadKey>> getAllThreadList();

  Stream<List<UserKey>> getAllUserList();

  Stream<ThreadKey> createThreadByUser(UserKey otherUser);

  Stream<ThreadKey> createMessageThread(String name, UserKey otherUser);

  Stream<ThreadKey> getThreadByMsgKey(String msgKey);

  Stream<List<ThreadKey>> getThreadList();

  Stream<Message> sendMessage(ThreadKey threads, Message message);

  Stream<List<Message>> getMessage(ThreadKey threads);
}
