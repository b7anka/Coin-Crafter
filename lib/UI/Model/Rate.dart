import 'package:currency_convertor/UI/Helpers/Constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Rate
{
    int id;
    String code;
    double value;
    TextEditingController controller;
    Map<String, String> name;
    String currencySymbol;
    bool allCurrencies;
    bool mostValuable;
    bool mostTraded;
    bool crypto;
    String img;

    Rate();

    Rate.fromMap(Map map)
    {
      id = map[Constants.ID_COLUMN];
      code = map[Constants.CURRENCY_CODE_COLUMN];
      value = double.parse(map[Constants.VALUE_COLUMN]);
      name = {
        "en": map["name"] != null ? map["name"][Constants.NAME_EN_COLUMN] : map[Constants.NAME_EN_COLUMN],
        "pt": map["name"] != null ? map["name"][Constants.NAME_PT_COLUMN] : map[Constants.NAME_PT_COLUMN]
      };
      currencySymbol = map[Constants.SYMBOL_COLUMN];
      allCurrencies = map[Constants.ALL_CURRENCIES_COLUMN] == 1;
      mostValuable = map[Constants.MOST_VALUABLE_COLUMN] == 1;
      mostTraded = map[Constants.MOST_TRADED_COLUMN] == 1;
      crypto = map[Constants.CRYPTO_COLUMN] == 1;
      img = map[Constants.IMG_COLUMN];
    }

    Map toMap()
    {
        Map<String, dynamic> map = {
          Constants.CURRENCY_CODE_COLUMN: code,
          Constants.VALUE_COLUMN: value,
          Constants.NAME_EN_COLUMN: name["en"],
          Constants.NAME_PT_COLUMN: name["pt"],
          Constants.SYMBOL_COLUMN: currencySymbol,
          Constants.ALL_CURRENCIES_COLUMN: allCurrencies,
          Constants.MOST_VALUABLE_COLUMN: mostValuable,
          Constants.MOST_TRADED_COLUMN: mostTraded,
          Constants.CRYPTO_COLUMN: crypto,
          Constants.IMG_COLUMN: img
        };

        if(id != null)
        {
          map[Constants.ID_COLUMN] = id;
        }

        return map;
    }

    @override
    String toString() {
      return "Rate(id: $id, value: $value, name_en: ${name["en"]}, name_pt: ${name["pt"]}, symbol: $currencySymbol, all_currencies: $allCurrencies, most_valuable: $mostValuable, most_traded: $mostTraded, crypto: $crypto, img: $img)";
    }

    @override
    bool operator ==(other) {
      if(other is! Rate){
        return false;
      }
      return code == (other as Rate).code;
    }


}