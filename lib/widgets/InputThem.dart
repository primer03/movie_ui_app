import 'package:flutter/material.dart';

class InputThem extends StatelessWidget {
  final Widget child;
  const InputThem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black, // Use single color directly
          onPrimary: Colors.white,
          secondary: Colors.blue,
          onSecondary: Colors.white,
          surface: Colors.grey[200]!,
          onSurface: Colors.black,

          error: Colors.red,
          onError: Colors.white,
        ),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.blue),
      ),
      child: child,
    );
  }
}
