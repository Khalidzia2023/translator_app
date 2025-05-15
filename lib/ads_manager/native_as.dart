
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class NativeAdController extends GetxController {

  NativeAd? _nativeAd;
  bool isAdReady = false;
  bool showAd = false;

  Rx<Widget> adWidget = Rx<Widget>(SizedBox.shrink());

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ));

      await remoteConfig.fetchAndActivate();

      // Fetch the `NativeAdvAd` boolean flag from Remote Config
      showAd = remoteConfig.getBool('NativeAd');
      print("######### Fetched value for 'NativeAd': $showAd");

      // Load the ad only if `showAd` is true
      if (showAd) {
        loadNativeAd();
      } else {
        adWidget.value = SizedBox.shrink();
        update();
      }
    } catch (e) {
      print('######## Error fetching Remote Config: $e');
      showAd = false;
    }
  }

  // Load the Native Ad
  void loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3118392277684870/9266070792',  // actual ID
      // adUnitId: 'ca-app-pub-3940256099942544/2247696110', // tested Id
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print("Native Ad Loaded.");
          isAdReady = true;
          updateAdWidget();
        },
        onAdFailedToLoad: (ad, error) {
          print("Native Ad Failed to Load: ${error.message}");
          ad.dispose();
          isAdReady = false;
          updateAdWidget();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        mainBackgroundColor: Colors.white,
        templateType: TemplateType.medium,
      ),
    );

    _nativeAd!.load();
  }
  void updateAdWidget() {
    if (isAdReady && _nativeAd != null) {
      adWidget.value = SizedBox(
        // height: 370,
        // margin: EdgeInsets.all(10),
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      adWidget.value = SizedBox.shrink();
    }
    update();
  }


  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }
}

// class NativeAdController2 extends GetxController {
//
//   NativeAd? _nativeAd;
//   bool isAdReady = false;
//   bool showAd = false;
//
//   Rx<Widget> adWidget = Rx<Widget>(SizedBox.shrink());
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeRemoteConfig();
//   }
//
//   Future<void> initializeRemoteConfig() async {
//     final remoteConfig = FirebaseRemoteConfig.instance;
//
//     try {
//       await remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(seconds: 1),
//       ));
//
//       await remoteConfig.fetchAndActivate();
//
//       // Fetch the `NativeAdvAd` boolean flag from Remote Config
//       showAd = remoteConfig.getBool('NativeAd');
//       print("######### Fetched value for 'NativeAd': $showAd");
//
//       // Load the ad only if `showAd` is true
//       if (showAd) {
//         loadNativeAd();
//       } else {
//         adWidget.value = SizedBox.shrink();
//         update();
//       }
//     } catch (e) {
//       print('######## Error fetching Remote Config: $e');
//       showAd = false;
//     }
//   }
//
//   // Load the Native Ad
//   void loadNativeAd() {
//     _nativeAd = NativeAd(
//       // adUnitId: 'ca-app-pub-3940256099942544/2247696110',
//       adUnitId: 'ca-app-pub-3118392277684870/9266070792',
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           print("Native Ad Loaded.");
//           isAdReady = true;
//           updateAdWidget();
//         },
//         onAdFailedToLoad: (ad, error) {
//           print("Native Ad Failed to Load: ${error.message}");
//           ad.dispose();
//           isAdReady = false;
//           updateAdWidget();
//         },
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         mainBackgroundColor: Colors.white,
//         templateType: TemplateType.medium,
//       ),
//     );
//
//     _nativeAd!.load();
//   }
//   void updateAdWidget() {
//     if (isAdReady && _nativeAd != null) {
//       adWidget.value = SizedBox(
//         // height: 370,
//         // margin: EdgeInsets.all(10),
//         child: AdWidget(ad: _nativeAd!),
//       );
//     } else {
//       adWidget.value = SizedBox.shrink();
//     }
//     update();
//   }
//
//
//   @override
//   void onClose() {
//     _nativeAd?.dispose();
//     super.onClose();
//   }
// }
//
// class NativeAdController3 extends GetxController {
//
//   NativeAd? _nativeAd;
//   bool isAdReady = false;
//   bool showAd = false;
//
//   Rx<Widget> adWidget = Rx<Widget>(SizedBox.shrink());
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeRemoteConfig();
//   }
//
//   Future<void> initializeRemoteConfig() async {
//     final remoteConfig = FirebaseRemoteConfig.instance;
//
//     try {
//       await remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(seconds: 1),
//       ));
//
//       await remoteConfig.fetchAndActivate();
//
//       // Fetch the `NativeAdvAd` boolean flag from Remote Config
//       showAd = remoteConfig.getBool('NativeAd');
//       print("######### Fetched value for 'NativeAd': $showAd");
//
//       // Load the ad only if `showAd` is true
//       if (showAd) {
//         loadNativeAd();
//       } else {
//         adWidget.value = SizedBox.shrink();
//         update();
//       }
//     } catch (e) {
//       print('######## Error fetching Remote Config: $e');
//       showAd = false;
//     }
//   }
//
//   // Load the Native Ad
//   void loadNativeAd() {
//     _nativeAd = NativeAd(
//       adUnitId: 'ca-app-pub-3118392277684870/9266070792',
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           print("Native Ad Loaded.");
//           isAdReady = true;
//           updateAdWidget();
//         },
//         onAdFailedToLoad: (ad, error) {
//           print("Native Ad Failed to Load: ${error.message}");
//           ad.dispose();
//           isAdReady = false;
//           updateAdWidget();
//         },
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         mainBackgroundColor: Colors.white,
//         templateType: TemplateType.medium,
//       ),
//     );
//
//     _nativeAd!.load();
//   }
//   void updateAdWidget() {
//     if (isAdReady && _nativeAd != null) {
//       adWidget.value = SizedBox(
//         // height: 370,
//         // margin: EdgeInsets.all(10),
//         child: AdWidget(ad: _nativeAd!),
//       );
//     } else {
//       adWidget.value = SizedBox.shrink();
//     }
//     update();
//   }
//
//
//   @override
//   void onClose() {
//     _nativeAd?.dispose();
//     super.onClose();
//   }
// }
