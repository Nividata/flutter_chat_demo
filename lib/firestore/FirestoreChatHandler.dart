import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_chat_demo/firestore/Ref.dart';
import 'package:flutter_chat_demo/firestore/RxFirestore.dart';
import 'package:flutter_chat_demo/firestream/Chat/UserThread.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseChatHandler.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/firestream/Chat/FbMessage.dart';
import 'package:flutter_chat_demo/firestream/Chat/Message.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/firestore/rx/Extension.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class FirestoreChatHandler extends FirebaseChatHandler {
  @override
  Stream<User> currentUserData(Path path) {
    return RxFirestore()
        .get(Ref.document(Paths.userPath()))
        .parseToListData()
        .map((event) => User.fromListData(event))
        .flatMap((value) => RxFirestore()
            .getByQuery(Ref.collection(Paths.messagesPath()))
            .parseToListOfListData()
            .map((event) => UserThread.fromListData(event))
            .toList()
            .asStream()
            .map((event) => Tuple2(value, event)))
        .map((Tuple2<User, List<UserThread>> event) {
      event.item1.userThread = event.item2;
      return event.item1;
    });
  }

  @override
  Stream<Message> listenOnChat(Path path, Thread threads, String uid) {
    Fimber.e("${path.toString()} ${uid} ${threads.toJson()}");
    return RxFirestore()
        .onByQuery(Ref.collection(path).limit(10))
        .parseToListData1()
        .map((event) => Message.fromFbMessageKey(
            FbMessageKey.fromJson(event.id, event.data), uid));
  }

  @override
  Stream<Message> sendMessage(
      Path path, Thread threads, Message message, String uid) {
    message.from = uid;
    message.isMe = true;
    return RxFirestore()
        .add(
            Ref.collection(Paths.chatMessagesPath(threads.id)),
            Message(msgType: "text", time: "11:50", text: "hi")
                .toFbMessage()
                .toJson())
        .map((event) => message);
  }

  @override
  Stream<Thread> createThreadByUser(User otherUser, String uid) {
    return currentUserData(Paths.userPathByUid(otherUser.id))
        .flatMap((User otherUser) => currentUserData(Paths.userPath())
                .map((User currentUser) => currentUser.userThread)
                .expand((element) => element)
                .map((event) => event.id)
                .where((event) {
              print(otherUser.userThread.map((e) => e.id).contains(event));
              return otherUser.userThread.map((e) => e.id).contains(event);
            }).defaultIfEmpty(""))
        .flatMap((String value) {
      if (value.isEmpty) {
        return createMessageThread(
            Paths.messagesPath(), "oneToOne", otherUser, uid);
      } else {
        return getThreadByMsgKey(Paths.chatsPath(), value);
      }
    });
  }

  @override
  Stream<Thread> getThreadByMsgKey(Path path, String msgKey) {
    Fimber.e("${path.toString()} ${msgKey}");
    return RxFirestore()
        .getByQuery(
            Ref.collection(path).where(FieldPath.documentId, isEqualTo: msgKey))
        .parseToListOfListData()
        .map((event) {
      Fimber.e("${Thread.fromListData(event)}");
      return Thread.fromListData(event);
    });
  }

  @override
  Stream<Thread> createMessageThread(
      Path path, String name, User otherUser, String uid) {
    String key = Ref.collection(path).document().documentID;
    Fimber.e(Ref.collection(path).document().documentID);

    return ZipStream([
      RxFirestore().set(Ref.document(Paths.messagePath(key)),
          UserThread(invitedBy: uid).toJson()),
      RxFirestore().set(Ref.document(Paths.messagePathByUid(otherUser.id, key)),
          UserThread(invitedBy: otherUser.id).toJson()),
      RxFirestore().set(
          Ref.document(Paths.chatPath(key)),
          Thread(name: name, type: 1, creator: uid, idList: [otherUser.id, uid])
              .toJson())
    ], (List<void> b) {
      Fimber.e("ZipStream ${b.runtimeType}");
      return b.length.toString();
    }).flatMap((value) {
      return getThreadByMsgKey(Paths.chatsPath(), key);
    });
  }
}
