import 'dart:io';
import 'package:currency_convertor/UI/About/send_email.dart';
import 'package:currency_convertor/UI/Helpers/AlertManager.dart';
import 'package:currency_convertor/UI/Helpers/Constants.dart';
import 'package:currency_convertor/UI/Helpers/LocalizationsManager.dart';
import 'package:currency_convertor/UI/WebView/webview_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:launch_review/launch_review.dart';
import 'package:currency_convertor/UI/Helpers/NetworkManager.dart';

class AboutPage extends StatelessWidget {
  LocalizationsManager l;
  BuildContext context;
  AlertManager alertManager;

  AboutPage(this.context) {
    l = LocalizationsManager(context);
    alertManager = AlertManager(context);
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(l.translate("about_title"),
              style: TextStyle(color: Colors.white, fontSize: 25.0)),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: _getItems(),
        )
            )
        )
    );
  }

  List<Widget> _getItems() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Container(
              width: 250.0,
              height: 250.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                        "images/developer.jpg",
                      ),
                      fit: BoxFit.cover)),
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                child: Text(
                  l.translate("developer_name"),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                child: Text(
                  l.translate("developer_email"),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      color: Colors.amber,
                      child: Text(
                        l.translate("send_email_btn"),
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        _showSendEmailPage();
                      })
                  : RaisedButton(
                      color: Colors.amber,
                      child: Text(
                        l.translate("send_email_btn").toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        _showSendEmailPage();
                      },
                    ),
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      color: Colors.amber,
                      child: Text(
                        l.translate("rate_my_app_btn"),
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        _rateMyApp();
                      })
                  : RaisedButton(
                      color: Colors.amber,
                      child: Text(
                        l.translate("rate_my_app_btn").toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        _rateMyApp();
                      },
                    ),
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 15.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      color: Colors.amber,
                      child: Text(
                        l.translate("privacy_policy_btn"),
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        _openPrivacyPolicy();
                      })
                  : RaisedButton(
                      color: Colors.amber,
                      child: Text(
                        l.translate("privacy_policy_btn").toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        _openPrivacyPolicy();
                      },
                    ),
            ),
          ),
        ],
      ),
      Padding(padding: EdgeInsets.only(top: 60.0),)
    ];
  }

  void _showSendEmailPage() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SendEmail(context)));

  void _rateMyApp() async {
    bool isInternetAvailable = await NetworkManager.isInternetAvailable();
    if(isInternetAvailable){
      LaunchReview.launch(androidAppId: Constants.APP_ID_PLAY_STORE, iOSAppId: Constants.APP_STORE_APP_ID);
    }else {
      alertManager.showNoInternetConnectionAvailable(Theme.of(context).platform);
    }
  }

  void _openPrivacyPolicy() async {
    bool isInternetAvailable = await NetworkManager.isInternetAvailable();
    if(isInternetAvailable){
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WebViewContainer(
              "${Constants.PRIVACY_POLICY_URL}${l.getLocale()}")));
    }else {
      alertManager.showNoInternetConnectionAvailable(Theme.of(context).platform);
    }
  }
}
