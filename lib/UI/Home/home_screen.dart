import 'dart:async';
import 'dart:io';

import 'package:currency_convertor/UI/About/about_page.dart';
import 'package:currency_convertor/UI/BuyPremium/buy_premium_screen.dart';
import 'package:currency_convertor/UI/Coin/coin_screen.dart';
import 'package:currency_convertor/UI/Helpers/AdsManager.dart';
import 'package:currency_convertor/UI/Helpers/AlertManager.dart';
import 'package:currency_convertor/UI/Helpers/Constants.dart';
import 'package:currency_convertor/UI/Helpers/LocalizationsManager.dart';
import 'package:currency_convertor/UI/Helpers/SharedPreferences.dart';
import 'package:currency_convertor/UI/Settings/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:currency_convertor/UI/Helpers/NetworkManager.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LocalizationsManager l;
  SharedPreferencesManager _prefs;
  AlertManager alertManager;

  Future<int> _initialPage;
  bool _userIsPremium;
  AdsManager adsManager;
  Timer interstitialTimer;

  @override
  void initState() {
    l = LocalizationsManager(context);
    alertManager = AlertManager(context);
    adsManager = AdsManager();
    _initialPage = _getPreferencesReady();
    super.initState();
  }


  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }

  void _showBannerAdd() async {
    adsManager.showBannerAd();
  }

  void _showInterstitialAd() async {
    adsManager.showInterstitialAd();
  }

  Widget _getBuyPremiumButton() {
    if (!_userIsPremium) {
      return IconButton(
        onPressed: () {
          _openPremiumPage();
        },
        icon: Icon(
          Icons.attach_money,
          color: Colors.white,
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialPage,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: Platform.isAndroid ? Theme(
                  data: Theme.of(context).copyWith(accentColor: Colors.amber),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ): CupertinoActivityIndicator(
                  animating: true,
                  radius: 20.0,
                ),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    l.translate("error_loading_data"),
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return DefaultTabController(
                initialIndex: _prefs.getStartScreenToUse(),
                length: 4,
                child: Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(
                      brightness: Brightness.dark,
                      title: Text(l.translate("app_title"),
                          style:
                              TextStyle(color: Colors.white, fontSize: 25.0)),
                      centerTitle: true,
                      backgroundColor: Colors.amber,
                      actions: <Widget>[
                        _getBuyPremiumButton(),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutPage(context)));
                          },
                          icon: Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                        )
                      ],
                      bottom:
                          TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                        Tab(
                          child: Text(
                            l.translate("most_common_currencies"),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Tab(
                          child: Text(
                            l.translate("most_valuable_currencies"),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Tab(
                          child: Text(
                            l.translate("crypto_currencies"),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Tab(
                          child: Text(
                            l.translate("all_currencies"),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ]),
                    ),
                    body: TabBarView(children: [
                      Coin(Constants.MOST_COMMON_CURRENCIES),
                      Coin(Constants.MOST_VALUABLE_CURRENCIES),
                      Coin(Constants.CRYPTO_CURRENCIES),
                      Coin(Constants.ALL_CURRENCIES)
                    ])),
              );
            }
        }
      },
    );
  }

  Future<int> _getPreferencesReady() async {
    _prefs = SharedPreferencesManager();
    await _prefs.isPrefsReady();
    _userIsPremium = _prefs.getUserPremium();
    if(!_userIsPremium){
      _showBannerAdd();
      _startTimers();
    }
    return Future.value(_prefs.getStartScreenToUse());
  }

  void _openPremiumPage() async {
    bool isInternetAvailable = await NetworkManager.isInternetAvailable();
    if(isInternetAvailable){
      _stopTimers();
      bool result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => BuyPremium()));
      if(result){
        adsManager.disposeInterstitialAd();
        adsManager.disposeBannerAd();
        setState(() {
          _userIsPremium = result;
        });
      }else {
        _startTimers();
      }
    }else {
      alertManager.showNoInternetConnectionAvailable(Theme.of(context).platform);
    }
  }

  void _startTimers() {
    interstitialTimer = Timer.periodic(Duration(minutes: 2), (Timer t) {
      _showInterstitialAd();
    });
  }

  void _stopTimers() {
    interstitialTimer.cancel();
  }
}
