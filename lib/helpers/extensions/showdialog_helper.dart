import 'package:flutter/cupertino.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';

@immutable
class ShowDialogHelper {
  const ShowDialogHelper._();

  static void showAlert({required String title, required String message}) {
    showCupertinoDialog(context: AppRouter.navigatorKey.currentContext!, builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true, 
            child: const Text(
              "확인", 
              style: TextStyle(
                color: AppColors.green10
              ),
            ), 
            onPressed: () {
              Navigator.pop(context);
            }
          )
        ],
      );
    });
  }

  static void showLoading() {
    showCupertinoDialog(context: AppRouter.navigatorKey.currentContext!, builder: (context) {
      return const CupertinoActivityIndicator();
    });
  }

  static void closeLoading() {
    AppRouter.pop();
  }
}