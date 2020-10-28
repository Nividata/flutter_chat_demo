import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/Chat/Message.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';

abstract class FirebaseChatHandler {
  Stream<User> currentUserData(Path path);
  Stream<Message> listenOnChat(Path path, ThreadKey threads, String uid);

  Stream<Message> sendMessage(
      Path path, ThreadKey threads, Message message, String uid);

  Stream<ThreadKey> createThreadByUser( User otherUser,String uid);
  Stream<ThreadKey> createMessageThread(Path path,String name, User otherUser,String uid);
  Stream<ThreadKey> getThreadByMsgKey(Path path, String msgKey);
}
