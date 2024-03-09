import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/feature/home/view/build_room_dialog.dart';
import 'package:sinking_us/feature/home/view/search_room_dialog.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

@immutable
class ShowDialogHelper {
  const ShowDialogHelper._();

  static Future<bool> gameEventDialog(
      {required String text, required Widget widget}) async {
    bool result = await showDialog(
        context: AppRouter.navigatorKey.currentContext!,
        barrierDismissible: false, // TODO: false
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.black,
              child: ClipRect(
                  child:
                      SizedBox(width: 455.3.w, height: 256.w, child: widget)));
        }).then((value) => value);
    return result;
  }

  static void showBuildRoomDialog() {
    showDialog(
        context: AppRouter.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Build Room"),
                content: SizedBox(
                    width: 400.w,
                    height: 300.h,
                    child: BuildDialogContent(
                      setState: setState,
                    )),
              );
            },
          );
        });
  }

  static void showSearchRoomDialog() {
    showDialog(
      context: AppRouter.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Search Room"),
          content: SizedBox(
              width: 400.w, height: 300.h, child: const SearchDialogContent()),
        );
      },
    );
  }

  static void showAlert({required String title, required String message}) {
    showCupertinoDialog(
        context: AppRouter.navigatorKey.currentContext!,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    tr("noti_ok"),
                    style: const TextStyle(color: AppColors.green10),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  static void showAlertWithAction(
      {required VoidCallback onPressed,
      required String title,
      required String message}) {
    showCupertinoDialog(
        context: AppRouter.navigatorKey.currentContext!,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  AppRouter.pop();
                  onPressed();
                },
                child: Text(
                  tr("noti_ok"),
                  style: const TextStyle(color: AppColors.green10),
                ),
              )
            ],
          );
        });
  }

  static void showSnackBar({required String content}) {
    ScaffoldMessenger.of(AppRouter.navigatorKey.currentContext!)
        .showSnackBar(SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: AppTypography.whitePixel,
      ),
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      width: 300.w,
      elevation: 30,
    ));
  }

  static void showLoading() {
    showCupertinoDialog(
        context: AppRouter.navigatorKey.currentContext!,
        builder: (context) {
          return const CupertinoActivityIndicator();
        });
  }

  static void closeLoading() {
    AppRouter.pop();
  }
}
