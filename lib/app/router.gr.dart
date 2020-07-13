// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_chat_demo/ui/splash/splash_view.dart';
import 'package:flutter_chat_demo/ui/signIn/signin_view.dart';
import 'package:flutter_chat_demo/ui/currentChat/current_chat_view.dart';
import 'package:flutter_chat_demo/ui/chat/chat_view.dart';
import 'package:flutter_chat_demo/models/response/Threads.dart';
import 'package:flutter_chat_demo/ui/AllUserList/all_user_view.dart';

class Routes {
  static const String splashView = '/splash-view';
  static const String signInView = '/sign-in-view';
  static const String currentChatView = '/current-chat-view';
  static const String chatView = '/chat-view';
  static const String allUserView = '/all-user-view';
  static const all = <String>{
    splashView,
    signInView,
    currentChatView,
    chatView,
    allUserView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.signInView, page: SignInView),
    RouteDef(Routes.currentChatView, page: CurrentChatView),
    RouteDef(Routes.chatView, page: ChatView),
    RouteDef(Routes.allUserView, page: AllUserView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashView: (RouteData data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashView(),
        settings: data,
      );
    },
    SignInView: (RouteData data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInView(),
        settings: data,
      );
    },
    CurrentChatView: (RouteData data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CurrentChatView(),
        settings: data,
      );
    },
    ChatView: (RouteData data) {
      var args = data.getArgs<ChatViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatView(threads: args.threads),
        settings: data,
      );
    },
    AllUserView: (RouteData data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AllUserView(),
        settings: data,
      );
    },
  };
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//ChatView arguments holder class
class ChatViewArguments {
  final Threads threads;
  ChatViewArguments({@required this.threads});
}
