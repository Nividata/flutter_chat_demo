import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_chat_demo/ui/signIn/signin_view.dart';
import 'package:flutter_chat_demo/ui/splash/splash_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: SignInView),
  ],
)
class $Router {}
