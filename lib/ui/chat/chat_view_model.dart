import 'package:firebase_database/firebase_database.dart';
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

  ChatViewModel() {
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
    _firebaseDbService.getThreadList().listen((List<Threads> snapshot) {
      snapshot.forEach((element) {
        print("${element.toJson()}");
      });
    }, onError: (e) {
      print(e);
    });
    /*_firebaseDbService.createMessageThread("oneToOne").listen((String snapshot) {
      print(snapshot);
    }, onError: (e) {
      print(e);
    });*/
  }

  getNewChatMessage() {}

  sendNewMessage() {}

  @override
  void dispose() {
    _sendMessageController.close();
    super.dispose();
  }
}
