// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

import './routes.dart';

@immutable
class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final routeBuilder = Routes.routeExist(routeName) ? Routes.getRoute(routeName) : Routes.getRoute(Routes.notFoundScreenRoute);

    return PageRouteBuilder<dynamic>(
      pageBuilder: (context, animation, secondaryAnimation) => routeBuilder(),
      transitionDuration: const Duration(milliseconds: 3200),
      reverseTransitionDuration: const Duration(milliseconds: 3200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.fastOutSlowIn));
        var fadedAnimation = animation.drive(tween);

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            double opacityValue;
            if (animation.value < 0.2) {
              opacityValue = animation.value / 0.2;
            } else if (animation.value < 0.8) {
              opacityValue = 1.0;
            } else {
              opacityValue = (1.0 - (animation.value - 0.8) / 0.2);
            }

            return Stack(
              children: [
                Opacity(
                  opacity: opacityValue,
                  child: Container(color: Colors.black),
                ),
                Opacity(
                  opacity: fadedAnimation.value,
                  child: child,
                ),
              ],
            );
          },
          child: child,
        );
      },
      settings: RouteSettings(
        name: '', //routeName,
        arguments: settings.arguments,
      ),
    );
  }

  static Future<dynamic> pushAndReplaceNamed(String routeName, {dynamic args}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: args);
  }

  static Future<dynamic> pushNamed(String routeName, {dynamic args}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: args,
    );
  }

  static Future<dynamic> push(Widget page) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<void> pop([dynamic result]) async {
    navigatorKey.currentState!.pop(result);
  }

  static Future<dynamic> popAndPushNamed(String routeName, {dynamic args}) {
    return navigatorKey.currentState!.popAndPushNamed(
      routeName,
      arguments: args,
    );
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(
      ModalRoute.withName(routeName),
    );
  }

  static void popUntilRoot() {
    navigatorKey.currentState!.popUntil(
      ModalRoute.withName(Routes.homeScreenRoute),
    );
  }
}
