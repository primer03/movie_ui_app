import 'package:bloctest/pages/login_page.dart';
import 'package:bloctest/pages/novel_detail.dart';
import 'package:bloctest/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:bloctest/pages/main_page.dart';
import 'package:socket_io_client/socket_io_client.dart';
// นำเข้าหน้าอื่นๆ ที่คุณต้องการใช้ route ด้วย

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/main':
        return MaterialPageRoute(builder: (_) => const Mainpage());
      case '/noveldetail':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => NovelDetail(
            novelId: args['novelId'],
            allep: args['allep'],
          ),
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
