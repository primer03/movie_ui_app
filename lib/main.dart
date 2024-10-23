import 'dart:async';
import 'dart:convert';

import 'package:bloctest/bloc/allcomment/allcomment_bloc.dart';
import 'package:bloctest/bloc/changeemail/changeemail_bloc.dart';
import 'package:bloctest/bloc/changepassword/changepassword_bloc.dart';
import 'package:bloctest/bloc/lineauth/lineauth_bloc.dart';
import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/novelbookmark/novelbookmark_bloc.dart';
import 'package:bloctest/bloc/novelcate/novel_cate_bloc.dart';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/bloc/novelread/readnovel_bloc.dart';
import 'package:bloctest/bloc/novelrec/novelrec_bloc.dart';
import 'package:bloctest/bloc/novelsearch/novelsearch_bloc.dart';
import 'package:bloctest/bloc/novelspecial/novelspecial_bloc.dart';
import 'package:bloctest/bloc/onboarding/onboarding_bloc.dart';
import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/bloc/visibility/visibility_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/function/line_auth.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:bloctest/routes/app_router.dart';
import 'package:bloctest/service/InappPurchaseservice.dart';
import 'package:bloctest/service/SocketService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';

// ignore: prefer_typing_uninitialized_variables
late Box novelBox;
final GlobalKey<ScaffoldMessengerState> globalScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  LineSDK.instance.setup('2002469697').then((_) {
    print('LineSDK Prepared');
  });
  await Firebase.initializeApp();
  // กำหนด path สำหรับ Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  novelBox = await Hive.openBox('NovelBox');
  bool hasData = novelBox.get('user') != null;
  novelBox.delete('searchData');
  novelBox.delete('cateID');
  novelBox.delete('searchDatabyName');
  novelBox.delete('bookmarkData');
  novelBox.delete('categoryData');
  novelBox.delete('ReadLast');
  novelBox.delete('specialData');
  getAppVersion();
  InAppPurchaseService();
  runApp(MyApp(initialRoute: hasData ? '/main' : '/'));
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  FlutterNativeSplash.remove();
}

Future<void> disableScreenSecurity() async {
  try {
    bool result = await NoScreenshot.instance.screenshotOn();
    debugPrint('Screenshot On: $result');
    print('Screen security disablexxxd');
  } on PlatformException catch (e) {
    print("Failed to disable screen security: '${e.message}'.");
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      print('close your app');
      disconnectSocket();
      WakelockPlus.disable();
      await disableScreenSecurity();
    } else if (state == AppLifecycleState.inactive) {
      print('inactive'); // คือเมื่อ app อยู่ในสถานะที่ไม่ได้ใช้งาน
    } else if (state == AppLifecycleState.paused) {
      print("App moved to background"); // คือเมื่อ app อยู่ในสถานะที่ถูกปิดไป
      disconnectSocket();
    } else if (state == AppLifecycleState.resumed) {
      bool hasdata = await novelBox.get('user') != null;
      bool? openWebview = await novelBox.get('openWebview');
      if (openWebview != null) {
        if (openWebview) {
          print('openWebview');
          await novelBox.delete('openWebview');
          print('delete openWebview');
        }
      } else {
        if (hasdata) {
          reconnectSocket();
        }
      }
      print(
          "App moved to foreground"); // คือเมื่อ app อยู่ในสถานะที่ถูกเปิดขึ้นมา
    }
  }
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: UserRepository()),
        ),
        BlocProvider<VisibilityBloc>(create: (context) => VisibilityBloc()),
        BlocProvider<PageBloc>(
            create: (context) =>
                PageBloc()..add(const PageScroll(isScrolling: true))),
        BlocProvider<OnboardingBloc>(
          create: (context) => OnboardingBloc(),
        ),
        BlocProvider<NovelCateBloc>(
          create: (context) => NovelCateBloc(),
        ),
        BlocProvider<NovelDetailBloc>(
          create: (context) => NovelDetailBloc(),
        ),
        BlocProvider<NovelsearchBloc>(
          create: (context) => NovelsearchBloc(),
        ),
        BlocProvider<NovelbookmarkBloc>(
          create: (context) => NovelbookmarkBloc(),
        ),
        BlocProvider<NovelspecialBloc>(create: (context) => NovelspecialBloc()),
        BlocProvider<NovelrecBloc>(create: (context) => NovelrecBloc()),
        BlocProvider<ReadnovelBloc>(create: (context) => ReadnovelBloc()),
        BlocProvider<LineauthBloc>(create: (context) => LineauthBloc()),
        BlocProvider<ChangeemailBloc>(create: (context) => ChangeemailBloc()),
        BlocProvider<AllcommentBloc>(create: (context) => AllcommentBloc()),
        BlocProvider<ChangepasswordBloc>(
            create: (context) => ChangepasswordBloc()),
        widget.initialRoute != '/'
            ? BlocProvider<NovelBloc>(
                create: (context) => NovelBloc()..add(FetchNovels()))
            : BlocProvider<NovelBloc>(create: (context) => NovelBloc()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: globalScaffoldMessengerKey,
        navigatorKey: globalNavigatorKey,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('th', 'TH'),
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter().onGenerateRoute,
        initialRoute: '/',
      ),
    );
  }
}
