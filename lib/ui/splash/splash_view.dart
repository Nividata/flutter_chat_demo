import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/ui/splash/splash_view_model.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SplashViewModel(),
      builder: (context, SplashViewModel model, child) => SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 32),
                child: Center(
                  child: CircularProgressIndicator(),
                ))),
      ),
    );
  }
}
