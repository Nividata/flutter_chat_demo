import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_chat_demo/ui/AllUserList/all_user_view.dart';
import 'package:flutter_chat_demo/ui/chat/chat_view.dart';
import 'package:flutter_chat_demo/ui/currentChat/current_chat_view.dart';
import 'package:flutter_chat_demo/ui/signIn/signin_view.dart';
import 'package:flutter_chat_demo/ui/splash/splash_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: SplashView),
    MaterialRoute(page: SignInView),
    MaterialRoute(page: CurrentChatView),
    MaterialRoute(page: ChatView),
    MaterialRoute(page: AllUserView),
  ],
)
class $Router1 {}
