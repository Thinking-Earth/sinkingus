import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';
import 'dart:async'; // Import for StreamSubscription

@immutable
class NetWorkStatusManagement {
  static final Connectivity _connectivity = Connectivity();
  static late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  const NetWorkStatusManagement._();

  static void init(WidgetRef ref) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.mobile) && !results.contains(ConnectivityResult.wifi)) {
        ShowDialogHelper.showAlertWithAction(
            onPressed: () {
              ref.read(matchDomainControllerProvider.notifier).leaveMatch();
              AppRouter.pushAndReplaceNamed(Routes.initialRoute);
            },
            title: "Warning",
            message: "Communication with the server was lost.");
      }
    });
  }

  static void dispose() {
    _connectivitySubscription.cancel();
  }
}