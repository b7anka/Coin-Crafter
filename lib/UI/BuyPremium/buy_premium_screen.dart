import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:currency_convertor/UI/Helpers/AlertManager.dart';
import 'package:currency_convertor/UI/Helpers/Constants.dart';
import 'package:currency_convertor/UI/Helpers/LocalNotificationsManager.dart';
import 'package:currency_convertor/UI/Helpers/LocalizationsManager.dart';
import 'package:currency_convertor/UI/Helpers/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_inapp_purchase/modules.dart';

class BuyPremium extends StatefulWidget {
  @override
  _BuyPremiumState createState() => _BuyPremiumState();
}

class _BuyPremiumState extends State<BuyPremium> {
  final List<String> _productLists = [
    Platform.isIOS
        ? Constants.IN_APP_PRODUCT_ID
        : Constants.IN_APP_PRODUCT_ID_ANDROID
  ];

  List<IAPItem> _items = [];

  SharedPreferencesManager _prefs;
  LocalizationsManager l;
  LocalNotificationsManager notificationsManager;
  AlertManager alertManager;
  bool isRestoring;
  List<Widget> _inAppPurchase;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferencesManager();
    l = LocalizationsManager(context);
    notificationsManager = LocalNotificationsManager();
    alertManager = AlertManager(context);
    isRestoring = false;
    initPlatformState();
  }

  @override
  void dispose() async {
    super.dispose();
    await FlutterInappPurchase.endConnection;
  }

  Future<void> initPlatformState() async {
    // prepare
    await FlutterInappPurchase.initConnection;
    _getPurchaseHistory();
  }

  Future<Null> _buyProduct() async {
    try {
      PurchasedItem purchased = await FlutterInappPurchase.buyProduct(
          Platform.isIOS
              ? Constants.IN_APP_PRODUCT_ID
              : Constants.IN_APP_PRODUCT_ID_ANDROID);

      if (Platform.isIOS) {
        validateReceipt(receiptIos: purchased.transactionReceipt);
      } else {
        validateReceipt(
            androidData: purchased.dataAndroid,
            androidSignature: purchased.signatureAndroid);
      }
    } catch (error) {
      print('$error');
    }
  }

  Future<Null> _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
    });
  }

  Future<Null> _getPurchaseHistory() async {
    List<PurchasedItem> items = await FlutterInappPurchase.getPurchaseHistory();
    for (var item in items) {
      if (item.productId == (Platform.isIOS ? Constants.IN_APP_PRODUCT_ID : Constants.IN_APP_PRODUCT_ID_ANDROID)) {
        setState(() {
          isRestoring = true;
        });
      }
    }
    if (items.length == 0) {
      _getProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

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
                    _requestToGoBack();
                  },
                ),
          brightness: Brightness.dark,
          title: Text(l.translate("premium_title"),
              style: TextStyle(color: Colors.white, fontSize: 25.0)),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: WillPopScope(
            child: SafeArea(
                child: SingleChildScrollView(
                  child: ListView(
                    padding: EdgeInsets.only(top: screenSize.height / 3.0),
                    shrinkWrap: true,
                    children: [
                      if(!isRestoring)...[
                        for (IAPItem item in _items) ...[
                          Text(
                            item.title,
                            style: TextStyle(color: Colors.white, fontSize: 40.0),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            item.description,
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15.0, left: 15.0),
                            child: Platform.isAndroid
                                ? RaisedButton(
                                color: Colors.amber,
                                child: Text(item.localizedPrice,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0)),
                                onPressed: () {
                                  _buyProduct();
                                })
                                : CupertinoButton(
                              color: Colors.amber,
                              onPressed: () {
                                _buyProduct();
                              },
                              child: Text(item.localizedPrice,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                            ),
                          )
                        ]
                      ]else...[
                        Padding(
                          padding: EdgeInsets.only(right: 15.0, left: 15.0),
                          child: Platform.isAndroid
                              ? RaisedButton(
                              color: Colors.amber,
                              child: Text(l.translate("restore_btn"),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              onPressed: () {
                                _getPremium(restored: true);
                              })
                              : CupertinoButton(
                            color: Colors.amber,
                            onPressed: () {
                              _getPremium(restored: true);
                            },
                            child: Text(l.translate("restore_btn"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0)),
                          ),
                        )
                      ]
                    ],
                  ),
                )
            ),
            onWillPop: (){
              _requestToGoBack();
              return Future.value(false);
            }
        )
    );
  }

  void _getPremium({bool restored}) async {
    await _prefs.isPrefsReady();
    _prefs.saveUserPremium(true);
    if (restored != null && restored) {
      notificationsManager.showNotification(l.translate("success_title"),
          l.translate("premium_restored_msg"), "");
      Navigator.pop(context, true);
    } else {
      Widget buttonOk = FlatButton(
          onPressed: () {
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          },
          child: Text(l.translate("ok_btn")));

      Widget buttonOkIOS = CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          },
          child: Text(l.translate("ok_btn")));

      alertManager.showAlertWithCustomTitleContentIconAndActions(
          Theme.of(context).platform,
          l.translate("success_title"),
          l.translate("premium_bought_successfully"),
          Icons.info,
          Colors.blue,
          [buttonOk],
          [buttonOkIOS]);
    }
  }

  void validateReceipt(
      {String receiptIos, androidData, androidSignature}) async {

    Map<String, String> data = {};

    if (receiptIos != null) {
        data["device"] = "ios";
        data["receiptIOS"] = receiptIos;
        data["is_sandbox"] = 'true';
    } else {
        data["device"] = "android";
        data["signed_data"] = androidData;
        data["signature"] = androidSignature;
    }

    var response =
    await http.post(Constants.URL_VERIFY_IN_APP_PURCHASED, body: data);
    var decodedData = json.decode(response.body);
    bool success = decodedData["success"];

    if (success) {
      _getPremium();
    } else {
      alertManager.showErrorAlertWithCustomContentAndOkAction(
          Theme.of(context).platform,
          l.translate("premium_could_not_be_verified"));
    }
  }

  void _requestToGoBack() {
    Navigator.pop(context, false);
  }
}
