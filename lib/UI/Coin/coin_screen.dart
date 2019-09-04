import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:currency_convertor/UI/Helpers/AlertManager.dart';
import 'package:currency_convertor/UI/Helpers/DatabaseManager.dart';
import 'package:currency_convertor/UI/Helpers/SharedPreferences.dart';
import 'package:currency_convertor/UI/Model/Rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:currency_convertor/UI/Helpers/Constants.dart';
import 'package:currency_convertor/UI/Helpers/NetworkManager.dart';
import 'package:currency_convertor/UI/Helpers/LocalizationsManager.dart';
import 'package:flutter/cupertino.dart';

class Coin extends StatefulWidget {
  @override

  String type;

  Coin(this.type);

  _CoinState createState() => _CoinState(this.type);
}

class _CoinState extends State<Coin> {

  String type;

  _CoinState(this.type);

  var _subscription;
  bool _isinternetAvailable;
  bool serverIsResponding;
  String _offlineInfoText;
  SharedPreferencesManager _prefs;
  AlertManager alertManager;
  LocalizationsManager l;
  DatabaseManager dbManager;
  List<Rate> rates;
  Future<Map> _data;
  String langCode;
  Widget _textFields;
  int index;
  int total;

  Size screenSize;

  bool mostValuableCurrencies;
  bool mostCommonCurrencies;
  bool allCurrencies;
  bool cryptoCurrencies;

  @override
  void initState() {
    super.initState();
    index = 0;
    _prefs = SharedPreferencesManager();
    alertManager = AlertManager(context);
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
          bool result = await NetworkManager.isInternetAvailable();
      setState(() {
        if(result){
          _prefs.saveLastServerCall(time: 0);
        }
        _textFields = null;
        _isinternetAvailable = result;
        _data = getData();
      });
    });
    mostValuableCurrencies = false;
    mostCommonCurrencies = false;
    allCurrencies = false;
    cryptoCurrencies = false;
    switch(this.type){
      case Constants.ALL_CURRENCIES:
        allCurrencies = true;
        break;
      case Constants.MOST_VALUABLE_CURRENCIES:
        mostValuableCurrencies = true;
        break;
      case Constants.CRYPTO_CURRENCIES:
        cryptoCurrencies = true;
        break;
      default:
        mostCommonCurrencies = true;
    }
    l = LocalizationsManager(context);
    dbManager = DatabaseManager();
    rates = [];
    _data = getData();
    Timer.periodic(Duration(minutes: 15), (Timer t) {
      if(_checkIfAppShouldGetRatesFromServerAgain()){
        setState(() {
          _data = getData();
        });
      }
    });
  }

  Future<Map> getData() async {
    _isinternetAvailable = await NetworkManager.isInternetAvailable();
    serverIsResponding = await NetworkManager.serverIsResponding();
    if (_isinternetAvailable) {
      if(_checkIfAppShouldGetRatesFromServerAgain()){
        if(serverIsResponding){
          http.Response response = await http.get("${Constants.URL_REQUEST}${l.getLocale()}", headers: {'Content-Type': 'application/json'});
          return json.decode(response.body);
        }else {
          return _fetchFromSQLite();
        }
      }else {
        return _fetchFromSQLite();
      }
    } else {
      return _fetchFromSQLite();
    }
  }

  void _makeCalculations(String text, Rate r) {
    if (text.trim().isEmpty) {
      _resetFields();
    } else {
      double value = double.parse(text);
      for(Rate rate in this.rates){
        if(r.code != Constants.EURO["key"]){
          if(rate != r){
            rate.controller.text = ((value * rate.value) / r.value).toStringAsFixed(rate.crypto ? _prefs.getHowManyDecimalDigitsToUseForCrypto() : _prefs.getHowManyDecimalDigitsToUse());
          }else if(r.code == Constants.EURO["key"]){
            rate.controller.text = (value / r.value).toStringAsFixed(rate.crypto ? _prefs.getHowManyDecimalDigitsToUseForCrypto() : _prefs.getHowManyDecimalDigitsToUse());
          }
        }else {
          if(rate != r){
            rate.controller.text = (value * rate.value).toStringAsFixed(rate.crypto ? _prefs.getHowManyDecimalDigitsToUseForCrypto() : _prefs.getHowManyDecimalDigitsToUse());
          }
        }
      }
    }
  }

  void _resetFields() {
    for(Rate r in rates){
      r.controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    Widget rateState = SafeArea(
        child:Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<Map>(
                      future: _data,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: screenSize.height / 3.0),
                                child: Platform.isAndroid ? Theme(
                                  data: Theme.of(context).copyWith(accentColor: Colors.amber),
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                ): CupertinoActivityIndicator(
                                  animating: true,
                                  radius: 20.0,
                                ),
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: screenSize.height / 3.0),
                                    child: Text(
                                      l.translate("error_loading_data"),
                                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              );
                            } else {
                              if(_textFields == null){
                                _defineExchangeRates(snapshot.data);
                                return _buildTextFields();
                              }else{
                                return _textFields;
                              }
                            }
                        }
                      }
                  )
                ],
              ),
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              child: Container(
                width: screenSize.width,
                height: 80.0,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: screenSize.width / 15.0,
                    ),
                    Icon(
                      Icons.monetization_on,
                      size: 70.0,
                      color: Colors.amber,
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: _resetFields,
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
    return rateState;
  }

  void _defineExchangeRates(Map data) async {

    this.rates.clear();

    List rates = data["rates"];

    if(rates.length > 0){
      TextEditingController euroController = TextEditingController();
      Rate euro = Rate();
      euro.crypto = false;
      euro.mostValuable = true;
      euro.mostTraded = true;
      euro.currencySymbol = l.translate("euro_symbol");
      euro.allCurrencies = true;
      euro.name = {
        "en":l.translate("euro_name"),
        "pt":l.translate("euro_name")
      };
      euro.code = Constants.EURO["key"];
      euro.value = 1.0;
      euro.controller = euroController;
      this.rates.add(euro);


      for(Map<String, dynamic> m in rates){
        Rate r = Rate.fromMap(m);
        TextEditingController controller = TextEditingController();
        r.controller = controller;
        dbManager.checkIfRateExists(r);
        this.rates.add(r);
      }

      if (data["type"] != null) {
        await _prefs.isPrefsReady();
        _prefs.saveLastExchangeRatesDate(data["date"]);
        _prefs.saveLastServerCall();
      }

      _offlineInfoText = data["type"] == null ? _prefs.getLastExchangeRatesDate() : Constants.NOTHING;
    }

  }

  Widget _buildTextFields() {
    Widget textFields = Padding(
      padding: EdgeInsets.only(top: 80.0),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(!_isinternetAvailable)...[
              if(rates.length == 0)...[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    l.translate("no_data_to_show"),
                    style: TextStyle(
                        color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                )
              ]else...[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "${l.translate("no_internet_connection_using_fallback_rates")} $_offlineInfoText. ${l.translate("connect_again_to_internet")}",
                    style: TextStyle(
                        color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                )
              ]
            ],
            for(Rate r in rates)...[
              if(mostCommonCurrencies)...[
                if(r.mostTraded)...[
                  buildTextField(r, r.name[l.getLocale()], _makeCalculations)
                ]
              ]else if(mostValuableCurrencies)...[
                if(r.mostValuable)...[
                  buildTextField(r, r.name[l.getLocale()], _makeCalculations)
                ]
              ]else if(cryptoCurrencies)...[
                if(r.crypto)...[
                  buildTextField(r, r.name[l.getLocale()], _makeCalculations)
                ]
              ]else...[
                buildTextField(r, r.name[l.getLocale()], _makeCalculations)
              ]
            ],
            Padding(padding: EdgeInsets.only(bottom: 50.0),)
          ],
        ),
      ),
    );
    _textFields = textFields;
    return textFields;
  }

  bool _checkIfAppShouldGetRatesFromServerAgain() {
    int lastCallToServer = _prefs.getLastServerCall();
    int now = DateTime.now().millisecondsSinceEpoch;

    if(now > lastCallToServer){
      return true;
    }
    return false;
  }

  Future<Map> _fetchFromSQLite() async {
    await _prefs.isPrefsReady();
    return dbManager.getAllRates();
  }
}

Widget buildTextField(Rate r, String name, Function f) {

  var unescaped = HtmlUnescape();
  String convertedName = unescaped.convert(name);
  return TextField(
      decoration: InputDecoration(
        labelText: convertedName,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 20.0),
        border: OutlineInputBorder(),
        prefixText: r.currencySymbol,
        suffixIcon: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: r.code == Constants.EURO["key"] ? AssetImage('images/eur.png') : MemoryImage(base64Decode(r.img)),
                      fit: BoxFit.cover
                  )
              ),
              child: GestureDetector(
                onTap: (){
                  WidgetsBinding.instance.addPostFrameCallback((_) => r.controller.clear());
                },
              ),
            ),
      ),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      controller: r.controller,
      onChanged: (text){
        f(text, r);
      },
      onSubmitted: (text){
        f(text, r);
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true));
}
