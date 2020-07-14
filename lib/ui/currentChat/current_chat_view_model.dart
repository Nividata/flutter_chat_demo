import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CurrentChatViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();

  CurrentChatViewModel() {
    getActiveChatList();
  }

  List<ThreadKey> _currentChatList = List();

  List<ThreadKey> get currentChatList => _currentChatList;

  getActiveChatList() {
    _firebaseDbService.getThreadList().listen((List<ThreadKey> list) {
      _currentChatList.addAll(list);
      notifyListeners();
    }, onError: (e) {
      print(e);
    });
  }

  onChatSelect(int index) {
    _navigationService.navigateTo(Routes.chatView,
        arguments: ChatViewArguments(threads: _currentChatList[index]));
  }

  onAddClick() {
    _navigationService.navigateTo(Routes.allUserView);
  }
}
