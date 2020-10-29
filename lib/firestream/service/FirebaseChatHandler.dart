import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/Chat/Message.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';

abstract class FirebaseChatHandler {
  Stream<User> currentUserData(Path path);
  Stream<Message> listenOnChat(Path path, Thread threads, String uid);

  Stream<Message> sendMessage(
      Path path, Thread threads, Message message, String uid);

  Stream<Thread> createThreadByUser( User otherUser,String uid);
  Stream<Thread> createMessageThread(Path path,String name, User otherUser,String uid);
  Stream<Thread> getThreadByMsgKey(Path path, String msgKey);
}
