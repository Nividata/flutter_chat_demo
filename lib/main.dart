import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/realtime/RealtimeService.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/locator.dart';
import 'app/router.gr.dart';
import 'main_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FireStream().initialize(RealtimeService());
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => MainViewModel(),
      builder: (context, MainViewModel model, child) => MaterialApp(
        title: 'Flutter Chat Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute:
            model.isLoggedIn ? Routes.currentChatView : Routes.signInView,
        onGenerateRoute: Router(),
        navigatorKey: locator<NavigationService>().navigatorKey,
      ),
    );
  }
}
