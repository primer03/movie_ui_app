import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/pages/category_page.dart';
import 'package:bloctest/pages/login_page.dart';
import 'package:bloctest/pages/novel_detail.dart';
import 'package:bloctest/pages/profile_page.dart';
import 'package:bloctest/pages/register_page.dart';
import 'package:bloctest/pages/search_page.dart';
import 'package:bloctest/widgets/SlideLeftPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:bloctest/pages/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:socket_io_client/socket_io_client.dart';

class AppRouter {
  bool hasData = novelBox.get('user') != null;
  Route onGenerateRoute(RouteSettings settings) {
    print(hasData);
    if (hasData) {
      novelBox.put('loginType', 'remember');
    }
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => hasData ? const Mainpage() : const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/main':
        return MaterialPageRoute(builder: (_) => const Mainpage());
      case '/login':
        return SlideLeftRoute(
          page: const LoginPage(),
        );
      case '/noveldetail':
        final args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: BlocProvider.value(
            // รับ Bloc จาก arguments แทนที่จะเรียกใช้ context โดยตรง
            value: args['bloc'] as NovelDetailBloc,
            child: NovelDetail(
              novelId: args['novelId'],
              allep: args['allep'],
            ),
          ),
        );
      case '/profile':
        return SlideLeftRoute(
          page: const ProfilePage(),
        );
      case '/category':
        final args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: CategoryPage(cateId: args['cateId'], cate: args['cate']),
        );
      case '/search':
        return PageTransition(
          child: const SearchPage(),
          type: PageTransitionType.rightToLeft,
          curve: Curves.easeInOut,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
