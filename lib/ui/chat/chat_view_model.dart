import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  FirebaseDbService _firebaseDbService = locator<FirebaseDbService>();
  final BehaviorSubject _sendMessageController = BehaviorSubject<String>();

  Function(String) get newMessage => _sendMessageController.sink.add;
  ThreadKey _threads;

  ChatViewModel(this._threads) {
    getChatMessageList();
  }

  int _currentTabIndex = 0;

  List<Message> _currentChatList = List();

  int get currentTabIndex => _currentTabIndex;

  List<Message> get currentChatList => _currentChatList;

  onBackClick() {
    _navigationService.back();
  }

  getChatMessageList() {
    _firebaseDbService.getMessage(_threads).listen((List<Message> list) {
      _currentChatList.addAll(list);
      notifyListeners();
    }, onError: (e) {
      print(e);
    });
  }

  sendNewMessage() {
    _firebaseDbService
        .sendMessage(
            _threads,
            Message(
                msgType: "text",
                time: "11:50",
                from: _threads.key,
                text: _sendMessageController.value))
        .listen((event) {
      _currentChatList.add(Message(
          msgType: "text",
          time: "11:50",
          from: _threads.key,
          text: _sendMessageController.value));
      notifyListeners();
    }, onError: (e) {
      print(e);
    });
  }

  @override
  void dispose() {
    _sendMessageController.close();
    super.dispose();
  }
}
