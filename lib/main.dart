import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/novelbookmark/novelbookmark_bloc.dart';
import 'package:bloctest/bloc/novelcate/novel_cate_bloc.dart';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/bloc/novelread/readnovel_bloc.dart';
import 'package:bloctest/bloc/novelsearch/novelsearch_bloc.dart';
import 'package:bloctest/bloc/onboarding/onboarding_bloc.dart';
import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/bloc/visibility/visibility_bloc.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:bloctest/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// ignore: prefer_typing_uninitialized_variables
late Box novelBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  runApp(MyApp(initialRoute: hasData ? '/main' : '/'));
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      print('close your app');
    } else if (state == AppLifecycleState.inactive) {
      print('inactive'); // คือเมื่อ app อยู่ในสถานะที่ไม่ได้ใช้งาน
    } else if (state == AppLifecycleState.paused) {
      print("App moved to background"); // คือเมื่อ app อยู่ในสถานะที่ถูกปิดไป
    }
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);
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
        BlocProvider<ReadnovelBloc>(create: (context) => ReadnovelBloc()),
        initialRoute != '/'
            ? BlocProvider<NovelBloc>(
                create: (context) => NovelBloc()..add(FetchNovels()))
            : BlocProvider<NovelBloc>(create: (context) => NovelBloc()),
      ],
      child: MaterialApp(
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
