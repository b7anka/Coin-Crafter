import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'UI/Helpers/FlutterI18nDelegate.dart';
import 'UI/Home/home_screen.dart';

void main()
{
  Iterable<LocalizationsDelegate<dynamic>> localesDelegates = [
    FlutterI18nDelegate(useCountryCode: false, fallbackFile: "en.json", path: "assets/flutter_i18n"),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];

    runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: localesDelegates,
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white
      ),
    ));
}
