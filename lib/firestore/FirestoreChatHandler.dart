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
import 'package:tuple/tuple.dart';

class FirestoreChatHandler extends FirebaseChatHandler {
  @override
  Stream<UserKey> currentUserData(Path path) {
    return RxFirestore()
        .get(Ref.document(Paths.userPath()))
        .parseToListData()
        .map((event) => UserKey.fromJson(event.id, event.data))
        .flatMap((value) => RxFirestore()
            .getByQuery(Ref.collection(Paths.messagesPath()))
            .parseToListOfListData()
            .map((event) => MsgKey.fromJson(event.id, event.data))
            .toList()
            .asStream()
            .map((event) => Tuple2(value, event)))
        .map((Tuple2<UserKey, List<MsgKey>> event) {
      event.item1.user.msgKey = event.item2;
      return event.item1;
    });
  }

  @override
  Stream<Message> listenOnChat(Path path, ThreadKey threads, String uid) {
    Fimber.e("${path.toString()} ${uid} ${threads.toJson()}");
    return RxFirestore()
        .onByQuery(Ref.collection(path).limit(10))
        .parseToListData1()
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
    return currentUserData(Paths.userPathByUid(otherUser.key))
        .flatMap((UserKey otherUser) => currentUserData(Paths.userPath())
                .map((UserKey currentUser) => currentUser.user.msgKey)
                .expand((element) => element)
                .map((event) => event.key)
                .where((event) {
              print(otherUser.user.msgKey.map((e) => e.key).contains(event));
              return otherUser.user.msgKey.map((e) => e.key).contains(event);
            }).defaultIfEmpty(""))
        .flatMap((String value) {
      Fimber.e("createThreadByUser $value");
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
    Fimber.e("${path.toString()} ${msgKey}");
    return RxFirestore()
        .getByQuery(
            Ref.collection(path).where(FieldPath.documentId, isEqualTo: msgKey))
        .parseToListOfListData()
        .map((event) {
      Fimber.e("${ThreadKey.fromJson(event.id, event.data)}");
      return ThreadKey.fromJson(event.id, event.data);
    });
  }

  @override
  Stream<ThreadKey> createMessageThread(
      Path path, String name, UserKey otherUser, String uid) {
    String key = Ref.collection(path).document().documentID;
    Fimber.e(Ref.collection(path).document().documentID);

    return ZipStream([
      RxFirestore()
          .set(Ref.document(Paths.messagePath(key)), {"owner": "$uid"}),
      RxFirestore().set(
          Ref.document(Paths.messagePathByUid(otherUser.key, key)),
          {"owner": "${otherUser.key}"}),
      RxFirestore().set(Ref.document(Paths.chatPath(key)),
          Thread(name: name, type: "oneToOne", owner: uid).toJson())
    ], (List<void> b) {
      Fimber.e("ZipStream ${b.runtimeType}");
      return b.length.toString();
    }).flatMap((value) {
      return getThreadByMsgKey(Paths.chatsPath(), key);
    });
  }
}
