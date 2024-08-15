import 'package:bloctest/pages/login_page.dart';
import 'package:bloctest/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:bloctest/pages/main_page.dart';
// นำเข้าหน้าอื่นๆ ที่คุณต้องการใช้ route ด้วย

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      // เพิ่ม case สำหรับหน้าอื่นๆ ที่นี่
      // case '/secondPage':
      //   return MaterialPageRoute(builder: (_) => const SecondPage());
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
