import 'package:flutter_chat_demo/firestream/service/FirebaseCoreHandler.dart';
import 'package:flutter_chat_demo/firestream/utility/Path.dart';
import 'package:flutter_chat_demo/realtime/RXRealtime.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:flutter_chat_demo/realtime/parse_to_listdata.dart';

import 'Ref.dart';

class RealtimeCoreHandler extends FirebaseCoreHandler {
  @override
  Stream<void> addUsers(Path path, User user) {
    return Stream.fromFuture(Ref.get(path).update(user.toJson()));
  }

  @override
  Stream<List<UserKey>> getAllUserList(Path path) {
    return RXRealtime()
        .get(Ref.get(path))
        .parseToListData()
        .expand((element) => element)
        .map((event) => UserKey(key: event.id, user: User.fromJson(event.data)))
        .toList()
        .asStream();
  }

  @override
  Stream<void> updateUsers(String path, Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}
