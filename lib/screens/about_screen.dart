import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // WebViewController _controller;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Help'),
          centerTitle: false,
        ),
        body: CircularProgressIndicator()
        // : WebView(
        //     initialUrl: 'about:blank',
        //     onWebViewCreated: (controller) {
        //       _controller = controller;
        //       setState(() {
        //         _isLoading = true;
        //       });
        //       _loadHtmlFromAssets();
        //     },
        //   ),
        );
  }

  // _loadHtmlFromAssets() async {
  //   String fileText =
  //       await rootBundle.loadString('assets/html/about/about.html');
  //   _controller.loadUrl(Uri.dataFromString(
  //     fileText,
  //     mimeType: 'text/html',
  //     encoding: Encoding.getByName('utf-8'),
  //   ).toString());
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
}
