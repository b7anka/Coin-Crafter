import 'dart:io';

import 'package:currency_convertor/UI/Helpers/LocalizationsManager.dart';
import 'package:currency_convertor/UI/Helpers/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  LocalizationsManager l;
  SharedPreferencesManager _prefs;
  String _currentScreen;

  List<String> startScreensOptions = [
    "most_common_currencies",
    "most_valuable_currencies",
    "crypto_currencies",
    "all_currencies"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;


  @override
  void initState() {
    l = LocalizationsManager(context);
    _init();
    super.initState();
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
          title: Text(l.translate("settings_title"),
              style: TextStyle(color: Colors.white, fontSize: 25.0)),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80.0,
                    child: Center(
                      child: Text(
                        l.translate("choose_start_screen"),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    width: double.infinity,
                    height: 50.0,
                    color: Colors.black,
                    child: Center(
                      child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: Theme(
                                data: Theme.of(context).copyWith(canvasColor: Colors.black),
                                child: DropdownButton(
                                    value: _currentScreen,
                                    items: _dropDownMenuItems,
                                    onChanged: changedDropDownItem
                                )
                            ),
                          )
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 80.0,
                    child: Center(
                      child: Text(
                        l.translate("choose_decimal_digits"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 50.0,
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Slider(
                                activeColor: Colors.amber,
                                value: _prefs.getHowManyDecimalDigitsToUse().toDouble(),
                                min: 0.0,
                                max: 15.0,
                                onChanged: (value){
                                  _prefs.saveHowManyDecimalDigitsToUse(value.round());
                                  setState(() {
                                  });
                                }
                            ),
                          ),
                          Text(_prefs.getHowManyDecimalDigitsToUse().toString(), style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 80.0,
                    child: Center(
                      child: Text(
                        l.translate("choose_decimal_digits_for_crypto"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 50.0,
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Slider(
                                activeColor: Colors.amber,
                                value: _prefs.getHowManyDecimalDigitsToUseForCrypto().toDouble(),
                                min: 0.0,
                                max: 15.0,
                                onChanged: (value){
                                  _prefs.saveHowManyDecimalDigitsToUseForCrypto(value.round());
                                  setState(() {
                                  });
                                }
                            ),
                          ),
                          Text(_prefs.getHowManyDecimalDigitsToUseForCrypto().toString(), style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 60.0),)
                ],
              ),
            )
        )
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String screen in startScreensOptions) {
      String localizedText = l.translate(screen);
      items.add(new DropdownMenuItem(
          value: screen,
          child: new Text(localizedText, style: TextStyle(color: Colors.white),)
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedScreen) {
    int index = startScreensOptions.indexOf(selectedScreen);
    _prefs.saveStartScreenToStart(index);
    setState(() {
      _currentScreen = _dropDownMenuItems[_prefs.getStartScreenToUse()].value;
    });
  }

  void _init() async {
    _prefs = SharedPreferencesManager();
    await _prefs.isPrefsReady();
    _dropDownMenuItems = getDropDownMenuItems();
    setState(() {
      _currentScreen = _dropDownMenuItems[_prefs.getStartScreenToUse()].value;
    });
  }
}
