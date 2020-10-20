import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/firestream/utility/Keys.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';

class Paths {
  static Path root() {
    return Path.fromPath("");
  }

  static Path usersPath() {
    return root().child(Keys.Users);
  }

  static Path userPathByUid(String uid) {
    return usersPath().child(uid);
  }

  static Path userPath() {
    return userPathByUid(currentUserId());
  }

  static Path messagesPathByUid(String uid) {
    return userPathByUid(uid).child(Keys.Messages);
  }

  static Path messagesPath() {
    return messagesPathByUid(currentUserId());
  }

  static Path userChatsPath() {
    return userPathByUid(currentUserId()).child(Keys.Chats);
  }

  static Path userMutedPath() {
    return userPathByUid(currentUserId()).child(Keys.Muted);
  }

  static Path userGroupChatPath(String chatId) {
    return userChatsPath().child(chatId);
  }

  static Path messagePath(String messageId) {
    return messagePathByUid(currentUserId(), messageId);
  }

  static Path messagePathByUid(String uid, String messageId) {
    return messagesPathByUid(uid).child(messageId);
  }

  static String currentUserId() {
    return FireStream.shared().currentUserId();
  }

  static Path contactsPath() {
    return userPath().child(Keys.Contacts);
  }

  static Path blockedPath() {
    return userPath().child(Keys.Blocked);
  }

  static Path chatsPath() {
    return root().child(Keys.Chats);
  }

  static Path chatPath(String chatId) {
    return chatsPath().child(chatId);
  }

  static Path chatMetaPath(String chatId) {
    return chatsPath().child(chatId).child(Keys.Meta);
  }

  static Path chatMessagesPath(String chatId) {
    return chatPath(chatId).child(Keys.Messages);
  }

  static Path chatMessagePathByMessageId(String chatId){
    return chatsPath().child(chatId).child(Keys.Meta);
  }

  static Path chatUsersPath(String chatId) {
    return chatPath(chatId).child(Keys.Users);
  }
}
