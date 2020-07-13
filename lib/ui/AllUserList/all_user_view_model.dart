import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllUserViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();

  AllUserViewModel() {
    getActiveChatList();
  }

  List<User> _currentChatList = List();

  List<User> get currentChatList => _currentChatList;

  getActiveChatList() {
    _firebaseDbService.getAllUserList().listen((List<User> list) {
      _currentChatList.addAll(list);
      notifyListeners();
    }, onError: (e) {
      print(e);
    });
  }


  onChatSelect(int index) {
//    _navigationService.navigateTo(Routes.chatView,
//        arguments: ChatViewArguments(threads: _currentChatList[index]));
  }
}
