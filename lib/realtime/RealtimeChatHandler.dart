import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseChatHandler.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/models/response/FbMessage.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/realtime/RXRealtime.dart';
import 'package:flutter_chat_demo/realtime/Ref.dart';
import 'package:flutter_chat_demo/realtime/rx/parse_to_listdata.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:rxdart/rxdart.dart';

class RealtimeChatHandler extends FirebaseChatHandler {
  @override
  Stream<UserKey> currentUserData(Path path) {
    return RXRealtime().get(Ref.get(path)).parseToListData().map((event) {
      print(UserKey.fromJson(event.id, event.data).toJson());
      return UserKey.fromJson(event.id, event.data);
    });
  }

  @override
  Stream<Message> listenOnChat(Path path, ThreadKey threads, String uid) {
    Query query = Ref.get(path).limitToLast(10);
    return RXRealtime().childOn(query).parseToListData().map((event) =>
        Message.fromFbMessageKey(
            FbMessageKey.fromJson(event.id, event.data), uid));
  }

  @override
  Stream<Message> sendMessage(
      Path path, ThreadKey threads, Message message, String uid) {
    message.from = uid;
    message.isMe = true;
    return RXRealtime()
        .add(Ref.get(path), message.toFbMessage().toJson())
        .map((event) => message);
  }

  @override
  Stream<ThreadKey> createThreadByUser( UserKey otherUser, String uid) {
    return currentUserData(Paths.userPath())
        .map((UserKey currentUser) => currentUser.user.msgKey)
        .expand((element) => element)
        .map((event) => event.key)
        .where(
            (event) => otherUser.user.msgKey.map((e) => e.key).contains(event))
        .defaultIfEmpty("")
        .flatMap((value) {
      if (value.isEmpty) {
        return createMessageThread(
            Paths.messagesPath(), "oneToOne", otherUser, uid);
      } else {
        return getThreadByMsgKey(Paths.chatsPath(), value);
      }
    });
  }

  @override
  Stream<ThreadKey> getThreadByMsgKey(Path path, String msgKey) {
    Query query = Ref.get(path).orderByKey().equalTo(msgKey);
    return RXRealtime().get(query).parseToListOfListData().map((event) {
      print(ThreadKey.fromJson(event.id, event.data));
      return ThreadKey.fromJson(event.id, event.data);
    });
  }

  @override
  Stream<ThreadKey> createMessageThread(
      Path path, String name, UserKey otherUser, String uid) {
    String key = Ref.get(path).push().key;

    return ZipStream([
      RXRealtime().add(Ref.get(Paths.messagePath(key)), {"owner": "$uid"}),
      RXRealtime().add(Ref.get(Paths.messagePathByUid(otherUser.key, key)),
          {"owner": "${otherUser.key}"}),
      RXRealtime().add(Ref.get(Paths.chatPath(key)),
          Thread(name: name, type: "oneToOne", owner: uid).toJson())
    ], (List<void> b) => b.length.toString())
        .flatMap((value) => getThreadByMsgKey(Paths.chatPath(key), key));
  }
}
