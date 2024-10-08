import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/pages/cate/category_page.dart';
import 'package:bloctest/pages/auth/login_page.dart';
import 'package:bloctest/pages/detail/novel_detail.dart';
import 'package:bloctest/pages/detail/novel_detail_new.dart';
import 'package:bloctest/pages/profile/profile_page.dart';
import 'package:bloctest/pages/reader/reader_page.dart';
import 'package:bloctest/pages/auth/register_page.dart';
import 'package:bloctest/pages/search/search_page.dart';
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
      print('user ${novelBox.get('user')}');
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
            child: NovelDetailNew(
              novelId: args['novelId'],
              allep: args['allep'],
              user: args['user'],
            ),
          ),
        );
      case '/profile':
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const ProfilePage(),
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
      case 'reader':
        final args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          child: ReaderPage(
            bookId: args['bookId'],
            epId: args['epId'],
            bookName: args['bookName'],
            novelEp: args['novelEp'],
          ),
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
