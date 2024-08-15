import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/onboarding/onboarding_bloc.dart';
import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/bloc/visibility/visibility_bloc.dart';
import 'package:bloctest/pages/main_page.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:bloctest/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      print('close your app');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc(userRepository: UserRepository())..add(LoadUser()),
        ),
        BlocProvider<VisibilityBloc>(create: (context) => VisibilityBloc()),
        BlocProvider<PageBloc>(
            create: (context) =>
                PageBloc()..add(const PageScroll(isScrolling: true))),
        BlocProvider<OnboardingBloc>(
          create: (context) => OnboardingBloc(),
        ),
        BlocProvider(create: (context) => NovelBloc()..add(FetchNovels())),
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
