import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/firestream/Chat/Message.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();

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
    FireStream.shared().listenOnChat(_threads).listen((Message message) {
      if (message != null) {
        _currentChatList.add(message);
        notifyListeners();
      }
    }, onError: (e) {
      print(e);
    });
  }

  sendNewMessage() {
    FireStream.shared()
        .sendMessage(
            _threads,
            Message(
                msgType: "text",
                time: "11:50",
                text: _sendMessageController.value))
        .listen((Message message) {
      print(message.toJson());
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
