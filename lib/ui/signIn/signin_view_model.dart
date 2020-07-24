import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:flutter_chat_demo/services/shared_preferences_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:flutter_chat_demo/utility/PreferencesUtil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tuple/tuple.dart';

class SignInViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _spPreferences = locator<SharedPreferencesService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  bool _codeSend = false;

  bool get codeSend => _codeSend;

  String _verificationId = "";

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

  final BehaviorSubject _phoneNumberController =
      BehaviorSubject<String>.seeded(userDate[0]);
  final BehaviorSubject _otpController =
      BehaviorSubject<String>.seeded(userDate[1]);

  Function(String) get changePhoneNumber => _phoneNumberController.sink.add;

  Function(String) get changeOtp => _otpController.sink.add;

  onOtpSend(String phoneNumber) {
    _authenticationService.sendOtp(phoneNumber).listen(
        (Tuple2<String, dynamic> tuple2) {
      if (tuple2.item1 == "Auto_verify") {
        onAutoOtpVerify(tuple2.item2 as AuthCredential);
      } else if (tuple2.item1 == "Code_send") {
        _codeSend = true;
        _verificationId = tuple2.item2 as String;
        notifyListeners();
      } else {
        _verificationId = tuple2.item2 as String;
      }
    }, onError: (e) {
      print(e);
    });
  }

  onOtpVerify(String otp) {
    _authenticationService.verifyOtp(_verificationId, otp).listen(
        (AuthResult authResult) {
      FireStream.shared()
          .addUsers(User(name: userDate[2], avatarUrl: userDate[3]))
          .listen((event) {
        _spPreferences.putString(PreferencesUtil.TOKEN, authResult.user.uid);
        _navigationService.replaceWith(Routes.currentChatView);
      }, onError: (e) {
        print(e);
      });
    }, onError: (e) {
      print(e);
    });
  }

  onAutoOtpVerify(AuthCredential credential) {
    _authenticationService.autoVerify(credential).listen(
        (AuthResult authResult) {
      FireStream.shared()
          .addUsers(User(name: userDate[2], avatarUrl: userDate[3]))
          .listen((event) {
        _spPreferences.putString(PreferencesUtil.TOKEN, authResult.user.uid);
        _navigationService.replaceWith(Routes.currentChatView);
      }, onError: (e) {
        print(e);
      });
    }, onError: (e) {
      print(e);
    });
  }

  onSignInClick() {
    if (_codeSend) {
      onOtpVerify(_otpController.value);
    } else {
      onOtpSend(_phoneNumberController.value);
    }
  }

  @override
  void dispose() {
    _phoneNumberController.close();
    _otpController.close();
    super.dispose();
  }
}
