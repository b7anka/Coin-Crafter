import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';

class SharedPreferencesManager
{
  SharedPreferences prefs;

  SharedPreferencesManager()
  {
    isPrefsReady();
  }

  Future<bool> isPrefsReady() async
  {
    prefs = await SharedPreferences.getInstance();
    return prefs != null;
  }

  void saveLastServerCall({int time}) async{
    int timeStamp;
    if(time != null){
      timeStamp = time;
    }else{
      timeStamp = DateTime.now().millisecondsSinceEpoch + Constants.ONE_HOUR_IN_MILLIS;
    }
    await prefs.setInt(Constants.LAST_SERVER_CALL_TIMESTAMP, timeStamp);
  }

  void saveStartScreenToStart(int value) async {
    await prefs.setInt(Constants.START_SCREEN_TO_USE, value);
  }

  void saveHowManyDecimalDigitsToUse(int value) async {
    await prefs.setInt(Constants.DECIMAL_DIGITS_TO_USE, value);
  }

  void saveHowManyDecimalDigitsToUseForCrypto(int value) async {
    await prefs.setInt(Constants.DECIMAL_DIGITS_TO_USE_CRYPTO, value);
  }
  
  void saveLastExchangeRatesDate(String date) async {
    await prefs.setString(Constants.LAST_EXCHANGE_RATES_DATE, date);
  }

  void saveUserPremium(bool value) async {
    await prefs.setBool(Constants.USER_PREMIUM, value);
  }

  void saveHowManyResultsToShow(int value) async {
    await prefs.setInt(Constants.RESULTS_TO_SHOW, value);
  }

  int getLastServerCall() => prefs.getInt(Constants.LAST_SERVER_CALL_TIMESTAMP) ?? DateTime.now().millisecondsSinceEpoch - Constants.ONE_HOUR_IN_MILLIS;

  int getHowManyDecimalDigitsToUse() => prefs.getInt(Constants.DECIMAL_DIGITS_TO_USE) ?? Constants.NUMERIC_PRECISION;

  int getHowManyDecimalDigitsToUseForCrypto() => prefs.getInt(Constants.DECIMAL_DIGITS_TO_USE_CRYPTO) ?? Constants.NUMERIC_PRECISION_CRYPTO_CURRENCIES;

  int getStartScreenToUse() => prefs.getInt(Constants.START_SCREEN_TO_USE) ?? 0;

  int getHowManyResultsToShow() => prefs.getInt(Constants.RESULTS_TO_SHOW) ?? Constants.DEFAULT_RESULTS_TO_SHOW;

  String getLastExchangeRatesDate() => prefs.getString(Constants.LAST_EXCHANGE_RATES_DATE) ?? Constants.NOTHING;

  bool getUserPremium() => prefs.getBool(Constants.USER_PREMIUM) ?? false;
}