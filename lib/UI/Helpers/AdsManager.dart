import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

import 'Constants.dart';

///
/// Wrapper class for Firebase Admob (https://pub.dev/packages/firebase_admob)
/// To use this plugin you need to add this to your manifest file
///
/// <meta-data
/// android:name="com.google.android.gms.ads.APPLICATION_ID"
/// android:value="[ADMOB_APP_ID]"/>
///
/// And to Info.plist for IOS
///
/// <key>GADApplicationIdentifier</key>
/// <string>[ADMOB_APP_ID]</string>
///
/// You also need to configure a firebase project and follow the instructions to add it to your project
///
///

class AdsManager {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  AdsManager() {
    FirebaseAdMob.instance.initialize(appId: _getAppId());
  }

  /// Info targeting what type of ad will be displayed to the user

  MobileAdTargetingInfo _getTargetingInfo() {
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );
    return targetingInfo;
  }

  /// This function will load and show a banner ad to the user

  void showBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      targetingInfo: _getTargetingInfo(),
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    _bannerAd
      ..load()
      ..show(
        anchorOffset: Platform.isAndroid ? 5.0 : 20.0,
        anchorType: AnchorType.bottom,
      );
  }

  /// This function will load and show a fullscreen ad to the user

  void showInterstitialAd() {
    _interstitialAd = InterstitialAd(
      adUnitId: _getInterstitialAdUnitId(),
      targetingInfo: _getTargetingInfo(),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );

    _interstitialAd
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
      );
  }

  /// This function is pretty self explanatory, it will dispose and nullify the [_interstitialAd] variable
  /// Resulting in the ad to be dismissed

  void disposeInterstitialAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd.dispose();
      _interstitialAd = null;
    }
  }

  /// This function is pretty self explanatory, it will dispose and nullify the [_bannerAd] variable
  /// Resulting in the ad to be dismissed

  void disposeBannerAd() async {
    if (_bannerAd != null) {
      await _bannerAd.dispose();
      _bannerAd = null;
    }
  }

  /// Returns the app id depending on the target platform to the caller.

  String _getAppId() {
    if (Platform.isIOS) {
      return Constants.IOS_APP_ID;
    } else if (Platform.isAndroid) {
      return Constants.ANDROID_APP_ID;
    }
    return null;
  }

  /// Returns the banner id depending on the target platform to the caller.

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return Constants.IOS_BANNER_ID;
    } else if (Platform.isAndroid) {
      return Constants.ANDROID_BANNER_ID;
    }
    return null;
  }

  /// Returns the interstitial id depending on the target platform to the caller.

  String _getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return Constants.IOS_INTERSTITIAL_ID;
    } else if (Platform.isAndroid) {
      return Constants.ANDROID_INTERSTITIAL_ID;
    }
    return null;
  }

}
