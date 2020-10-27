import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllUserViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();

  AllUserViewModel() {
    getActiveChatList();
  }

  List<UserKey> _currentChatList = List();

  List<UserKey> get currentChatList => _currentChatList;

  getActiveChatList() {
    FireStream.shared().getAllUserList().listen((List<UserKey> list) {
      _currentChatList.addAll(list);
      notifyListeners();
      print(list.length);
    }, onError: (e) {
      print(e);
    });
  }

  onChatSelect(int index) {
    FireStream.shared().createThreadByUser(_currentChatList[index]).listen(
        (event) {
      print("onChatSelect ${event}");
      _navigationService.replaceWith(Routes.chatView,
          arguments: ChatViewArguments(threads: event));
    }, onError: (e) {
      print(e);
    });
  }
}
