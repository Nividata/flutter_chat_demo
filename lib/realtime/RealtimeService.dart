import 'package:flutter_chat_demo/firestream/service/FirebaseService.dart';
import 'package:flutter_chat_demo/realtime/RealtimeChatHandler.dart';

import 'RealtimeCoreHandler.dart';

class RealtimeService extends FirebaseService {
  RealtimeService() {
    core = RealtimeCoreHandler();
    chat = RealtimeChatHandler();
    print("ok1 ${core.toString()} ${chat.toString()}");
  }
}
