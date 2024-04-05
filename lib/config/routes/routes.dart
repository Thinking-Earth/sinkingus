import 'package:flutter/material.dart';
import 'package:sinking_us/feature/auth/presentation/view/login_screen.dart';
import 'package:sinking_us/feature/common/view/splash_screen.dart';
import 'package:sinking_us/feature/error/page_not_found_view.dart';
import 'package:sinking_us/feature/game/game_main.dart';
import 'package:sinking_us/feature/home/view/home_screen.dart';
import 'package:sinking_us/feature/result/view/result_screen.dart';

@immutable
class Routes{
  const Routes._();

  static const String initialRoute = '/';
  static const String notFoundScreenRoute = '/page-not-found';

  static const String loginScreenRoute = '/auth/login';
  static const String homeScreenRoute = '/home';

  static const String gameMainScreenRoute = '/game';
  static const String resultScreenRoute ='/game/result';

  static final Map<String, Widget Function()> _routesMap = {
    initialRoute: () => const SplashScreen(),
    notFoundScreenRoute: () => const PageNotFoundScreen(),

    loginScreenRoute: () => const LoginScreen(),
    homeScreenRoute: () => const HomeScreen(),

    gameMainScreenRoute: () => const GameMain(),
    resultScreenRoute: () => const ResultScreen()
  };

  static Widget Function() getRoute(String? routeName) {
    return routeExist(routeName)
        ? _routesMap[routeName]!
        : _routesMap[Routes.notFoundScreenRoute]!;
  }

  static bool routeExist(String? routeName){
    return _routesMap.containsKey(routeName);
  }
}