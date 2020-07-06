// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_chat_demo/ui/splash/splash_view.dart';
import 'package:flutter_chat_demo/ui/signIn/signin_view.dart';
import 'package:flutter_chat_demo/ui/chat/chat_view.dart';

class Routes {
  static const String splashView = '/';
  static const String signInView = '/sign-in-view';
  static const String chatView = '/chat-view';
  static const all = <String>{
    splashView,
    signInView,
    chatView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.signInView, page: SignInView),
    RouteDef(Routes.chatView, page: ChatView),
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
    ChatView: (RouteData data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatView(),
        settings: data,
      );
    },
  };
}
