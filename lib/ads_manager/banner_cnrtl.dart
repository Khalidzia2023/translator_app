//
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:shimmer/shimmer.dart';
//
// class BannerAdController extends GetxController {
//   final Map<String, BannerAd> _ads = {};
//   final Map<String, RxBool> _adLoaded = {};
//   RxBool isAdEnabled = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchRemoteConfig();
//     // loadBannerAd('large2');
//   }
//
//   Future<void> fetchRemoteConfig() async {
//     try {
//       final remoteConfig = FirebaseRemoteConfig.instance;
//
//       await remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(minutes: 1),
//       ));
//       await remoteConfig.fetchAndActivate();
//
//       bool bannerAdsEnabled = remoteConfig.getBool('BannerAd');
//       isAdEnabled.value = bannerAdsEnabled;
//
//       if (bannerAdsEnabled) {
//         // Preload ads for multiple locations
//         loadBannerAd('ad1');
//         loadBannerAd('ad2');
//         loadBannerAd('ad3'); // Add more as needed
//         loadBannerAd('ad4');
//         loadBannerAd('ad5');
//         loadBannerAd('large'); // Add more as needed
//         loadBannerAd('large1'); // Add more as needed
//         loadBannerAd('large2');
//       }
//     } catch (e) {
//       print('Error fetching Remote Config: $e');
//     }
//   }
//
//
//   // Load a banner ad for a specific key
//   void loadBannerAd(String key) async {
//     if (_ads.containsKey(key)) {
//       _ads[key]!.dispose();
//     }
//
//     final bannerAd = BannerAd(
//       // adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Your actual ad unit ID
//       adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Your tested ad unit ID
//       // Use an appropriate size for full width
//       size: AdSize.banner, // Standard banner size
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           _adLoaded[key] = true.obs;
//           print("Banner Ad Loaded for key: $key");
//         },
//         onAdFailedToLoad: (ad, error) {
//           _adLoaded[key] = false.obs;
//           print("Ad failed to load for key $key: ${error.message}");
//         },
//       ),
//     );
//
//     bannerAd.load();
//     _ads[key] = bannerAd;
//   }
//   Widget getBannerAdWidget(String key) {
//     if (isAdEnabled.value && _ads.containsKey(key) && _adLoaded[key]?.value == true) {
//       return Container(
//         height: 100, // Height to match banner size
//         width: double.infinity, // Full width
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//         ),
//         child: AdWidget(ad: _ads[key]!),
//       );
//     } else {
//       return Shimmer.fromColors(
//         baseColor: Colors.white12,
//         highlightColor: Colors.grey.shade900,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 60,
//             width: double.infinity, // Will also take full width during loading
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   void loadBannerAd1(String key) async {
//     if (_ads.containsKey(key)) {
//       _ads[key]!.dispose();
//     }
//
//     final bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Your actual ad unit ID
//       // Use an appropriate size for full width
//       size: AdSize.banner, // Standard banner size
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           _adLoaded[key] = true.obs;
//           print("Banner Ad Loaded for key: $key");
//         },
//         onAdFailedToLoad: (ad, error) {
//           _adLoaded[key] = false.obs;
//           print("Ad failed to load for key $key: ${error.message}");
//         },
//       ),
//     );
//
//     bannerAd.load();
//     _ads[key] = bannerAd;
//   }
//   Widget getBannerAdWidget1(String key) {
//     if (isAdEnabled.value && _ads.containsKey(key) && _adLoaded[key]?.value == true) {
//       return Container(
//         height: 100, // Height to match banner size
//         width: double.infinity, // Full width
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//         ),
//         child: AdWidget(ad: _ads[key]!),
//       );
//     } else {
//       return Shimmer.fromColors(
//         baseColor: Colors.white12,
//         highlightColor: Colors.grey.shade900,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 60,
//             width: double.infinity, // Will also take full width during loading
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   void loadBannerAd2(String key) async {
//     if (_ads.containsKey(key)) {
//       _ads[key]!.dispose();
//     }
//
//     final bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Your actual ad unit ID
//       // Use an appropriate size for full width
//       size: AdSize.banner, // Standard banner size
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           _adLoaded[key] = true.obs;
//           print("Banner Ad Loaded for key: $key");
//         },
//         onAdFailedToLoad: (ad, error) {
//           _adLoaded[key] = false.obs;
//           print("Ad failed to load for key $key: ${error.message}");
//         },
//       ),
//     );
//
//     bannerAd.load();
//     _ads[key] = bannerAd;
//   }
//   Widget getBannerAdWidget2(String key) {
//     if (isAdEnabled.value && _ads.containsKey(key) && _adLoaded[key]?.value == true) {
//       return Container(
//         height: 100, // Height to match banner size
//         width: double.infinity, // Full width
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2),
//         ),
//         child: AdWidget(ad: _ads[key]!),
//       );
//     } else {
//       return Shimmer.fromColors(
//         baseColor: Colors.white12,
//         highlightColor: Colors.grey.shade900,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 60,
//             width: double.infinity, // Will also take full width during loading
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//
//   @override
//   void onClose() {
//     for (final ad in _ads.values) {
//       ad.dispose();
//     }
//     super.onClose();
//   }
//
//
//
// }
//



import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class BannerAdController extends GetxController {
  final Map<String, BannerAd> _ads = {};
  final Map<String, RxBool> _adLoaded = {};
  RxBool isAdEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRemoteConfig();
  }

  Future<void> fetchRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ));
      await remoteConfig.fetchAndActivate();

      bool bannerAdsEnabled = remoteConfig.getBool('BannerAd');
      isAdEnabled.value = bannerAdsEnabled;

      if (bannerAdsEnabled) {
        // Preload ads for multiple locations
        loadBannerAd('ad1');
        loadBannerAd('ad2');
        loadBannerAd('ad3');
        loadBannerAd('ad4');
        loadBannerAd('ad5');
        loadBannerAd('ad6');
        loadBannerAd('large');
        loadBannerAd('large1');
        loadBannerAd('large2');
      }
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }
  bool isAdReady(String key) {
    return isAdEnabled.value && _ads.containsKey(key) && (_adLoaded[key]?.value ?? false);
  }

  // Load a banner ad for a specific key
  void loadBannerAd(String key) {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }

    final bannerAd = BannerAd(

      adUnitId: 'ca-app-pub-3118392277684870/8529610178', // actual ad unit ID
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.fluid,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key]?.value = true;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key]?.value = false;
          print("Ad failed for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
    _adLoaded[key] = false.obs; // Initialize as not loaded
  }
  Widget getBannerAdWidget(String key) {
    if (isAdReady(key)) {
      return Container(
        width: double.infinity,
        height: 80,
        child: AdWidget(ad: _ads[key]!),
      );
    } else {
      // Placeholder or shimmer while loading
      return Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.grey.shade900,
        child: Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    }
  }

  void loadBannerAd1(String key) {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }

    final bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Use your actual ad unit ID
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key]?.value = true;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key]?.value = false;
          print("Ad failed for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
    _adLoaded[key] = false.obs; // Initialize as not loaded
  }
  Widget getBannerAdWidget1(String key) {
    if (isAdReady(key)) {
      return Container(
        height: 60, // height for banner ad
        width: double.infinity,
        child: AdWidget(ad: _ads[key]!),
      );
    } else {
      // Placeholder or shimmer while loading
      return Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }
  }

  void loadBannerAd2(String key) {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }

    final bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Use your actual ad unit ID
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key]?.value = true;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key]?.value = false;
          print("Ad failed for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
    _adLoaded[key] = false.obs; // Initialize as not loaded
  }
  Widget getBannerAdWidget2(String key) {
    if (isAdReady(key)) {
      return Container(
        height: 60, // height for banner ad
        width: double.infinity,
        child: AdWidget(ad: _ads[key]!),
      );
    } else {
      // Placeholder or shimmer while loading
      return Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }
  }


  void loadBannerAd3(String key) {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }

    final bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Use your actual ad unit ID
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key]?.value = true;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key]?.value = false;
          print("Ad failed for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
    _adLoaded[key] = false.obs; // Initialize as not loaded
  }
  Widget getBannerAdWidget3(String key) {
    if (isAdReady(key)) {
      return Container(
        height: 60, // height for banner ad
        width: double.infinity,
        child: AdWidget(ad: _ads[key]!),
      );
    } else {
      // Placeholder or shimmer while loading
      return Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }
  }


  void loadBannerAd4(String key) {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }

    final bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Use your actual ad unit ID
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key]?.value = true;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key]?.value = false;
          print("Ad failed for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
    _adLoaded[key] = false.obs; // Initialize as not loaded
  }
  Widget getBannerAdWidget4(String key) {
    if (isAdReady(key)) {
      return Expanded(
        child: Container(
          height: 60,
          child: AdWidget(ad: _ads[key]!),
        ),
      );
    } else {
      // Placeholder or shimmer while loading
      return Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }
  }


  void loadBannerAd5(String key) {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }

    final bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3118392277684870/8529610178', // Use your actual ad unit ID
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key]?.value = true;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key]?.value = false;
          print("Ad failed for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
    _adLoaded[key] = false.obs; // Initialize as not loaded
  }
  Widget getBannerAdWidget5(String key) {
    if (isAdReady(key)) {
      return Container(
        height: 60, // height for banner ad
        width: double.infinity,
        child: AdWidget(ad: _ads[key]!),
      );
    } else {
      // Placeholder or shimmer while loading
      return Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }
  }

  @override
  void onClose() {
    for (final ad in _ads.values) {
      ad.dispose();
    }
    super.onClose();
  }
}
