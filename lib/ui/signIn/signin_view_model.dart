import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:flutter_chat_demo/services/shared_preferences_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:flutter_chat_demo/user/usecases/UserRepositoryImpl.dart';
import 'package:flutter_chat_demo/utility/PreferencesUtil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tuple/tuple.dart';

class SignInViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _spPreferences = locator<SharedPreferencesService>();
  UserRepositoryImpl _userRepository = locator<UserRepositoryImpl>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  bool _codeSend = false;

  bool get codeSend => _codeSend;

  String _verificationId = "";

  final BehaviorSubject _phoneNumberController =
      BehaviorSubject<String>.seeded("6354669944");
  final BehaviorSubject _otpController =
      BehaviorSubject<String>.seeded("123456");

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
      _spPreferences.putString(PreferencesUtil.TOKEN, authResult.user.uid);
      _userRepository
          .authenticate(User(name: "mehul2", avatarUrl: "www.google.com"))
          .listen((event) {
        _navigationService.replaceWith(Routes.chatView);
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
      _spPreferences.putString(PreferencesUtil.TOKEN, authResult.user.uid);
      _userRepository
          .authenticate(User(name: "mehul1", avatarUrl: "www.google.com"))
          .listen((event) {
        _navigationService.replaceWith(Routes.chatView);
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
