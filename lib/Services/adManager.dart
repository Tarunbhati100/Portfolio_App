import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4673674063813906~3491918640";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  } 
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4673674063813906/1421300832";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4673674063813906/5460618190";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  

}