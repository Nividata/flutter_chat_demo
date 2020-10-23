import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:flutter_chat_demo/utility/PreferencesUtil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:tuple/tuple.dart';

import 'app/locator.dart';
import 'services/shared_preferences_service.dart';

class TestViewModel extends BaseViewModel {
  static List userDate1 = [
    "1234512345",
    "123456",
    "mehul makwana",
    "www.mehul.com"
  ];

  static List userDate2 = [
    "1234512344",
    "123456",
    "chetan makwana",
    "www.chetan.com"
  ];

  static List userDate = userDate1;

  TestViewModel() {
    // createUserAccount(userDate);
  }

  SharedPreferencesService _spPreferences = locator<SharedPreferencesService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  createUserAccount(List userDate) {
    _authenticationService
        .sendOtp(userDate[0])
        .transform(FlatMapStreamTransformer((Tuple2<String, dynamic> tuple2) {
      if (tuple2.item1 == "Auto_verify") {
        return _authenticationService
            .autoVerify(tuple2.item2 as AuthCredential);
      } else {
        return _authenticationService.verifyOtp(
            tuple2.item2 as String, userDate[1]);
      }
    })).listen((AuthResult authResult) {
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
