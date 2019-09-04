import 'dart:io';

import 'package:currency_convertor/UI/Helpers/LocalizationsManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {

  String url;

  WebViewContainer(this.url);

  @override
  _WebViewContainerState createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {

  String url;
  final _key = UniqueKey();
  LocalizationsManager l;

  _WebViewContainerState(this.url);

  @override
  Widget build(BuildContext context) {
    l = LocalizationsManager(context);
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          leading: Platform.isAndroid
              ? BackButton(
            color: Colors.white,
          )
              : GestureDetector(
            child: Row(
              children: <Widget>[
                Icon(CupertinoIcons.back, color: Colors.white),
                Text(
                  l.translate("back_title"),
                  style: TextStyle(color: Colors.white, fontSize: 11.0),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          brightness: Brightness.dark,
          title: Text(l.translate("privacy_policy_btn"),
              style: TextStyle(color: Colors.white, fontSize: 25.0)),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: url)
            )
          ],
        )
    );
  }
}
