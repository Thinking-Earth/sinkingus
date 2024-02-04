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
    final Size realSize = MediaQuery.of(context).size;
    final Size customSize;
    if (realSize.width < 1334) {
      customSize = Size(1334, realSize.height);
    } else {
      customSize = realSize;
    }

    return ProviderScope(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(size: customSize),
        child: ScreenUtilInit(
          designSize: const Size(844, 390),
          useInheritedMediaQuery: true,
          builder: (context, widget) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1334),
                child: MaterialApp(
                  title: "Sinking US",
                  debugShowCheckedModeBanner: false,
                  initialRoute: Routes.initialRoute,
                  theme: AppTheme.light(),
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
              ),
            );
          },
        ),
      ),
    );
  }
}