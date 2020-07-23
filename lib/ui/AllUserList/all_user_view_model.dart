import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/services/firebase_db_service.dart';
import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllUserViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();
  FirestoreService _firestoreService = locator<FirestoreService>();

  AllUserViewModel() {
    getActiveChatList();
  }

  List<UserKey> _currentChatList = List();

  List<UserKey> get currentChatList => _currentChatList;

  getActiveChatList() {
    FireStream.shared()
        .getAllUserList()
        .listen((List<UserKey> list) {
      _currentChatList.addAll(list);
      notifyListeners();
    }, onError: (e) {
      print(e);
    });
  }

  onChatSelect(int index) {
    _firebaseDbService.createThreadByUser(_currentChatList[index]).listen(
        (event) {
      _navigationService.replaceWith(Routes.chatView,
          arguments: ChatViewArguments(threads: event));
    }, onError: (e) {
      print(e);
    });
  }
}
