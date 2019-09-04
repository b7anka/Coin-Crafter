import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter/material.dart';

class LocalizationsManager
{
  BuildContext context;
  final List<String> _supportedLocales = ["en", "pt"];

  LocalizationsManager(this.context);

  bool isLocaleSupported() => _supportedLocales.contains(FlutterI18n.currentLocale(context).languageCode);

  String getLocale()
  {
    if(isLocaleSupported()){
      return FlutterI18n.currentLocale(context).languageCode;
    }
    return _supportedLocales[0];
  }

  String translate(String key)
  {
    return FlutterI18n.translate(context, key);
  }

}