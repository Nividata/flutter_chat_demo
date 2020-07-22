import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';

abstract class FirebaseCoreHandler {
  Stream<void> addUsers(Path path, User user);

  Stream<List<UserKey>> getAllUserList(Path path);

  Stream<void> updateUsers(String path, Map<String, dynamic> data);
}
