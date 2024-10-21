import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookfetWebview extends StatefulWidget {
  const BookfetWebview({super.key});

  @override
  State<BookfetWebview> createState() => _BookfetWebviewState();
}

class _BookfetWebviewState extends State<BookfetWebview> {
  late final WebViewController _webViewController;
  final Uri uri = Uri.parse('https://bookfet.com/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://accounts.google.com/')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _webViewController)),
    );
  }
}
