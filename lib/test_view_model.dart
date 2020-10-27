import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/firestream/utility/Paths.dart';
import 'package:flutter_chat_demo/firestream/Chat/Message.dart';
import 'package:flutter_chat_demo/firestream/Chat/Threads.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:flutter_chat_demo/firestream/Chat/user.dart';
import 'package:flutter_chat_demo/utility/PreferencesUtil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_chat_demo/firestore/rx/Extension.dart';

import 'app/locator.dart';
import 'firestore/Ref.dart';
import 'firestore/RxFirestore.dart';
import 'services/shared_preferences_service.dart';

class TestViewModel extends BaseViewModel {
  static List userDate1 = [
    "1234512345",
    "123456",
    "mehul makwana1",
    "www.mehul.com"
  ];

  static List userDate2 = [
    "1234512344",
    "123456",
    "chetan makwana",
    "www.chetan.com"
  ];

  static List userDate = userDate2;

  SharedPreferencesService _spPreferences = locator<SharedPreferencesService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  TestViewModel() {
    // createUserAccount(userDate);
    getAllUserList();
    // getActiveChatList();
  }

  getChatMessageList(ThreadKey _threads) {
    FireStream.shared().listenOnChat(_threads).listen((Message message) {
      Fimber.e("${message?.toJson()}");
    }, onError: (e) {
      print(e);
    });
  }

  createThreadByUser(UserKey userKey) {
    FireStream.shared().createThreadByUser(userKey).listen((event) {
      getChatMessageList(event);
      print("onChatSelect ${event.toJson()}");
    }, onError: (e) {
      print(e);
    });
  }

  getAllUserList() {
    FireStream.shared().getAllUserList().listen((List<UserKey> list) {
      print("${list.length}");
      // createThreadByUser(list[0]);
    }, onError: (e) {
      print(e);
    });
  }

  getActiveChatList() {
    FireStream.shared()
        .getAllActiveChatUserList()
        .listen((List<ThreadKey> list) {}, onError: (e) {
      print(e);
    });
  }

  createUserAccount(List userDate) {
    _authenticationService
        .logout()
        .flatMap((value) => _authenticationService
                .sendOtp(userDate[0])
                .transform(
                    FlatMapStreamTransformer((Tuple2<String, dynamic> tuple2) {
              if (tuple2.item1 == "Auto_verify") {
                return _authenticationService
                    .autoVerify(tuple2.item2 as AuthCredential);
              } else {
                return _authenticationService.verifyOtp(
                    tuple2.item2 as String, userDate[1]);
              }
            })))
        .listen((AuthResult authResult) {
      FireStream.shared()
          .addUsers(User(name: userDate[2], avatarUrl: userDate[3]))
          .listen((event) {
        _spPreferences.putString(PreferencesUtil.TOKEN, authResult.user.uid);
        print("Account created");
      }, onError: (e) {
        print(e);
      });
    }, onError: (e) {
      print(e);
    });
  }
}
