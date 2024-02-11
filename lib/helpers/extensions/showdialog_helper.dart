import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';

@immutable
class ShowDialogHelper {
  const ShowDialogHelper._();

  static void miniGameDialog({required String title, required Widget widget}) {
    showDialog(
      context: AppRouter.navigatorKey.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                onPressed: (){
                  AppRouter.pop();
                },
                icon: const Icon(CupertinoIcons.xmark)
              ),
              const Spacer(),
              Text(title),
              const Spacer()
            ],
          ),
          content: SizedBox(
            width: 800.w,
            height: 360.h,
            child: widget
          )
        );
      }
    );
  }

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