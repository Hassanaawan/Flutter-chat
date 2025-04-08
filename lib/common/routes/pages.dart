import 'package:chat/common/middlewares/router_welcome.dart';
import 'package:chat/pages/Application/index.dart';
import 'package:chat/pages/Profile/index.dart';
import 'package:chat/pages/message/Chat/bindings.dart';
import 'package:chat/pages/message/Chat/view.dart';
import 'package:chat/pages/Contact/index.dart';

import 'package:chat/pages/Login/bindings.dart';
import 'package:chat/pages/Login/view.dart';
import 'package:chat/pages/welcome/bindings.dart';
import 'package:chat/pages/welcome/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPLICATION = AppRoutes.APPLICATION;

  static final RouteObserver<PageRoute> observer = RouteObserver<PageRoute>();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [
        RouteWelcomeMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.APPLICATION,
      page: () => ApplicationPage(),
      binding: ApplicationBindings(),
      // middlewares: [
      //   RouteWelcomeMiddleware(priority: 1),
      // ],
    ),
    GetPage(
      name: AppRoutes.CONTACT,
      page: () => ContactPage(),
      binding: ContactBindings(),
      // middlewares: [
      //   RouteWelcomeMiddleware(priority: 1),
      // ],
    ),
    GetPage(
      name: AppRoutes.CHAT,
      page: () => ChatPage(),
      binding: ChatBindings(),
      // middlewares: [
      //   RouteWelcomeMiddleware(priority: 1),
      // ],
    ),
    GetPage(
      name: AppRoutes.ME,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      // middlewares: [
      //   RouteWelcomeMiddleware(priority: 1),
      // ],
    ),
  ];
}
