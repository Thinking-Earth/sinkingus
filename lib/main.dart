import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/app_bootstrapper.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/helpers/constants/app_colors.dart';
import 'package:sinking_us/helpers/constants/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppBootstrapper.init(runApp: runApp);
}

// ignore: must_be_immutable
class SinkingUs extends StatelessWidget {
  SinkingUs({super.key, required this.idToken});
  String? idToken;

  @override
  Widget build(BuildContext context){
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        useInheritedMediaQuery: true,
        builder: (context, widget) {
          return Theme(
            data: AppThemes.mainTheme,
            child: MaterialApp(
              title: "Sinking US",
              debugShowCheckedModeBanner: false,
              initialRoute: idToken != null
                  ? Routes.HomeScreenRoute
                  : Routes.LoginScreenRoute,
              color: AppColors.primaryColor,
              onGenerateRoute: AppRouter.generateRoute,
              navigatorKey: AppRouter.navigatorKey,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ko', 'KR'),
              ],
            ),
          );
        },
      ),
    );
  }
}