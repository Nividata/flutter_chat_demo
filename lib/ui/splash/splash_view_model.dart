import 'package:flutter_chat_demo/app/locator.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();

  SplashViewModel() {
    Future.delayed(Duration(seconds: 1), () {
      _navigationService.replaceWith(Routes.signInView);
    });
  }
}
