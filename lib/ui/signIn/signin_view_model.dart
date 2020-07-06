import 'package:flutter_chat_demo/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();

  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  onTabSelectionChange(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  onForgotPwsClick() {
//    _navigationService.navigateTo(Routes.forgotPwsView);
  }

  onSignInClick() {
//    _navigationService.replaceWith(Routes.dashboardView);
  }
}
