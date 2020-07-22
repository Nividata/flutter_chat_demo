import 'package:flutter_chat_demo/firestream/service/FirebaseService.dart';

import 'RealtimeCoreHandler.dart';

class RealtimeService extends FirebaseService {
  RealtimeService() {
    core = RealtimeCoreHandler();
    print("ok1 ${core.toString()}");
  }
}
