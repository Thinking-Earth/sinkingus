import 'package:flutter/material.dart';
import 'package:sinking_us/presentation/auth/login_screen_view.dart';
import 'package:sinking_us/presentation/error/page_not_found_view.dart';
import 'package:sinking_us/presentation/home/home_screen_view.dart';

@immutable
class Routes{
  const Routes._();

  static const String initialRoute = '/';
  static const String NotFoundScreenRoute = '/page-found-screen';

  static const String LoginScreenRoute = '/auth/login';
  static const String HomeScreenRoute = '/home';

  static final Map<String, Widget Function()> _routesMap = {
    LoginScreenRoute: () => const LoginScreen(),
    NotFoundScreenRoute: () => const PageNotFoundScreen(),
    HomeScreenRoute: () => const HomeScreen(),
  };

  static Widget Function() getRoute(String? routeName) {
    return routeExist(routeName)
        ? _routesMap[routeName]!
        : _routesMap[Routes.NotFoundScreenRoute]!;
  }

  static bool routeExist(String? routeName){
    return _routesMap.containsKey(routeName);
  }
}