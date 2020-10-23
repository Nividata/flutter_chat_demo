import 'package:flutter_chat_demo/firestore/FirestoreCoreHandler.dart';
import 'package:flutter_chat_demo/firestream/service/FirebaseService.dart';

import 'FirestoreChatHandler.dart';

class FirestoreService extends FirebaseService {
  FirestoreService() {
    core = FirestoreCoreHandler();
    chat = FirestoreChatHandler();
  }
}
