import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/app/router.gr.dart';
import 'package:flutter_chat_demo/firestore/FirestoreService.dart';
import 'package:flutter_chat_demo/firestream/FireStream.dart';
import 'package:flutter_chat_demo/realtime/RealtimeService.dart';
import 'package:flutter_chat_demo/test_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/locator.dart';
import 'main_view_model.dart';

void main1() async {
  WidgetsFlutterBinding.ensureInitialized();
  FireStream().initialize(RealtimeService());
  Fimber.plantTree(DebugTree(useColors: true));
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
        onGenerateRoute: Router1(),
        navigatorKey: locator<NavigationService>().navigatorKey,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree(useColors: true));
  FireStream().initialize(RealtimeService());
  await setupLocator();
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => TestViewModel(),
        builder: (context, TestViewModel model, child) => MaterialApp(
              home: Text("ok"),
            ));
  }
}
