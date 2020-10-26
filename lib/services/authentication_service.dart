import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tuple/tuple.dart';

@lazySingleton
class AuthenticationService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> currentUser() => _auth.currentUser();

  Stream<Tuple2<String, dynamic>> sendOtp(String phoneNumber) {
    StreamController controller = StreamController<Tuple2<String, dynamic>>();

    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        timeout: Duration(seconds: 5),
        verificationCompleted: (AuthCredential authCredential) {
          controller.sink.add(Tuple2("Auto_verify", authCredential));
        },
        verificationFailed: (AuthException authException) {
          print("ok authException.message");
          controller.sink.addError(authException);
        },
        codeSent: (String verificationId, [int code]) {
          controller.sink.add(Tuple2("Code_send", verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          controller.sink.add(Tuple2("Timeout", verificationId));
        });
    return controller.stream;
  }

  Stream<AuthResult> verifyOtp(String verificationId, String otp) {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return Stream.fromFuture(_auth.signInWithCredential(credential));
  }

  Stream<AuthResult> autoVerify(AuthCredential credential) {
    return Stream.fromFuture(_auth.signInWithCredential(credential));
  }

  Stream<void> logout() {
    return Stream.fromFuture(_auth.signOut());
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        break;
      default:
        break;
    }
  }
}
