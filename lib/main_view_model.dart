import 'package:flutter_chat_demo/utility/PreferencesUtil.dart';
import 'package:stacked/stacked.dart';

import 'app/locator.dart';
import 'services/shared_preferences_service.dart';

class MainViewModel extends BaseViewModel {
  bool _isLoggedIn = locator<SharedPreferencesService>()
      .getString(PreferencesUtil.TOKEN)
      .isNotEmpty;

  bool get isLoggedIn => _isLoggedIn;
}
