import 'package:flutter_chat_demo/firestream/Chat/UserThread.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';

abstract class FirebaseCoreHandler {
  Stream<void> addUsers(Path path, User user);

  Stream<List<User>> getAllUserList(Path path, String uid);

  Stream<List<Thread>> getAllActiveChatUserList(Path path);

  Stream<List<UserThread>> getUserMessageThreadList(Path path);

  Stream<void> updateUsers(String path, Map<String, dynamic> data);

  Map<String, String> timestamp();
}
