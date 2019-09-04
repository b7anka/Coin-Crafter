import 'dart:io';

import 'package:connectivity/connectivity.dart';

import 'Constants.dart';

class NetworkManager {


  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool serverWasPinged = await _pingServer();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi && serverWasPinged) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  static Future<bool> _pingServer() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
    return Future.value(false);
  }

  static Future<bool> serverIsResponding() async{
    try {
      final result = await InternetAddress.lookup(Constants.SERVER_URL);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
    return Future.value(false);
  }

}