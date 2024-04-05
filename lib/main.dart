import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/app_bootstrapper.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/helpers/constants/app_themes.dart';

//*****************************************************/
// DO NOT PRESS RUN HERE
// 컨트롤 에프 5로 실행시키세요. 랜덤 포트 -> 49323으로 고정함 그래야 커스텀 로그인됨(credential 인증 어쩌고 땜시)
//*****************************************************/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppBootstrapper.init(runApp: runApp);
}

// ignore: must_be_immutable
class SinkingUs extends StatelessWidget {
  SinkingUs({super.key, required this.idToken});
  String? idToken;

  @override
  Widget build(BuildContext context) {
    Size realSize = MediaQuery.of(context).size;
    Size customSize;
    if ((844 / 390) > realSize.width / realSize.height) {
      customSize = Size(realSize.width, realSize.width * (390 / 844));
    } else {
      customSize = Size(realSize.height * (844 / 390), realSize.height);
    }

    return ProviderScope(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(size: customSize),
        child: ScreenUtilInit(
          designSize: const Size(844, 390),
          useInheritedMediaQuery: true,
          ensureScreenSize: true,
          minTextAdapt: true,
          builder: (context, widget) {
            return Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 844 / 390,
                  child: MaterialApp(
                    title: "Sinking US",
                    debugShowCheckedModeBanner: false,
                    initialRoute: Routes.initialRoute,
                    theme: AppTheme.light(),
                    onGenerateRoute: AppRouter.generateRoute,
                    navigatorKey: AppRouter.navigatorKey,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
