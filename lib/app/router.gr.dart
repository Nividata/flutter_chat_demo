// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../models/response/Threads.dart';
import '../ui/AllUserList/all_user_view.dart';
import '../ui/chat/chat_view.dart';
import '../ui/currentChat/current_chat_view.dart';
import '../ui/signIn/signin_view.dart';
import '../ui/splash/splash_view.dart';

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

class Router1 extends RouterBase {
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
    SplashView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashView(),
        settings: data,
      );
    },
    SignInView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInView(),
        settings: data,
      );
    },
    CurrentChatView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CurrentChatView(),
        settings: data,
      );
    },
    ChatView: (data) {
      final args = data.getArgs<ChatViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatView(threads: args.threads),
        settings: data,
      );
    },
    AllUserView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AllUserView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ChatView arguments holder class
class ChatViewArguments {
  final ThreadKey threads;
  ChatViewArguments({@required this.threads});
}
