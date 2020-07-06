import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'signin_view_model.dart';
import 'package:flutter_chat_demo/utility/ValidationExtension.dart';

class SignInView extends StatelessWidget {
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _otpFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SignInViewModel(),
      builder: (context, SignInViewModel model, child) => SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: 'Phone number',
                                      hintText: "9737563575"),
                                  focusNode: _phoneNumberFocus,
                                  onFieldSubmitted: (term) {
                                    _fieldFocusChange(context,
                                        _phoneNumberFocus, _otpFocus);
                                  },
                                  keyboardType: TextInputType.phone,
                                  validator: (String input) =>
                                      input.validNumber()),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      labelText: 'Otp', hintText: "123456"),
                                  focusNode: _otpFocus,
                                  keyboardType: TextInputType.number,
                                  validator: (String input) =>
                                      input.validOtp()),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 32),
                      child: FlatButton(
                        child: Text(
                          "SIGN IN",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.white),
                        ),
                        onPressed: model.onSignInClick,
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
