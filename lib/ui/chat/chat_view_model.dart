import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/models/response/Message.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tuple/tuple.dart';

class ChatViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final BehaviorSubject _sendMessageController = BehaviorSubject<String>();

  Function(String) get newMessage => _sendMessageController.sink.add;

  ChatMessageViewModel() {
    getChatMessageList();
    getNewChatMessage();
  }

  int _currentTabIndex = 0;

  List<Message> _currentChatList = List();

  int get currentTabIndex => _currentTabIndex;

  List<Message> get currentChatList => _currentChatList;

  onBackClick() {
    _navigationService.back();
  }

  getChatMessageList() {
  }

  getNewChatMessage() {
  }

  sendNewMessage() {

  }

  @override
  void dispose() {
    _sendMessageController.close();
    super.dispose();
  }
}
