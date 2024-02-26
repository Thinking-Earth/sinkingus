import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

@immutable 
class NetWorkStatusManagement {
  const NetWorkStatusManagement._();

  static void init() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result != ConnectivityResult.mobile || result != ConnectivityResult.wifi) {
        ShowDialogHelper.showAlertWithAction(
          onPressed: (){
            AppRouter.pushAndReplaceNamed(Routes.initialRoute);
          }, 
          title: "Warning", 
          message: "Communication with the server was lost."
        );
      }
    });
  }
}