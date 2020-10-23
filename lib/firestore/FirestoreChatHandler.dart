import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_chat_demo/firestore/Ref.dart';
import 'package:flutter_chat_demo/firestore/RxFirestore.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseChatHandler.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/models/response/FbMessage.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/firestore/rx/parse_to_listdata.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreChatHandler extends FirebaseChatHandler {
  @override
  Stream<UserKey> currentUserData(Path path) {
    return RxFirestore().get(Ref.document(path)).parseToListData().map((event) {
      Fimber.e("${UserKey.fromJson(event.id, event.data).toJson()}");
      return UserKey.fromJson(event.id, event.data);
    });
  }

  @override
  Stream<Message> listenOnChat(Path path, ThreadKey threads, String uid) {
    Fimber.e("${path.toString()} ${uid} ${threads.toJson()}");
    return RxFirestore()
        .getByQuery(Ref.collection(path).limit(10))
        .parseToListOfListData()
        .map((event) => Message.fromFbMessageKey(
            FbMessageKey.fromJson(event.id, event.data), uid));
  }

  @override
  Stream<Message> sendMessage(
      Path path, ThreadKey threads, Message message, String uid) {
    message.from = uid;
    message.isMe = true;
    return RxFirestore()
        .add(
            Ref.collection(Paths.chatMessagesPath(threads.key)),
            Message(msgType: "text", time: "11:50", text: "hi")
                .toFbMessage()
                .toJson())
        .map((event) => message);
  }

  @override
  Stream<ThreadKey> createThreadByUser(UserKey otherUser, String uid) {
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
    RxFirestore()
        .getByQuery(Ref.collection(Paths.chatsPath())
            .where(FieldPath.documentId, isEqualTo: msgKey))
        .parseToListOfListData()
        .map((event) {
      Fimber.e("${ThreadKey.fromJson(event.id, event.data)}");
      return ThreadKey.fromJson(event.id, event.data);
    });
  }

  @override
  Stream<ThreadKey> createMessageThread(
      Path path, String name, UserKey otherUser, String uid) {
    String key = Ref.collection(Paths.messagesPath()).document().documentID;

    ZipStream([
      RxFirestore()
          .set(Ref.document(Paths.messagePath(key)), {"owner": "$uid"}),
      RxFirestore().set(
          Ref.document(
              Paths.messagePathByUid("XFiyZE7K4oSXdb93TDhrTRZvzCs2", key)),
          {"owner": "${otherUser.key}"}),
      RxFirestore().set(Ref.document(Paths.chatPath(key)),
          Thread(name: name, type: "oneToOne", owner: uid).toJson())
    ], (List<void> b) => b.length.toString()).flatMap((value) {
      return getThreadByMsgKey(Paths.chatsPath(), key);
    });
  }
}
