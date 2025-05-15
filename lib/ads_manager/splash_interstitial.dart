import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class SplashInterstitialAd extends GetxController {
  InterstitialAd? _interstitialAd;
  // bool _hasShownAd = false;
  bool showInterstitialAd = true;

  @override
  void onInit() {
    super.onInit();
    loadInterstitialAd();
    fetchRemoteConfig();
  }

  /// Load the interstitial ad if ads are enabled
  void loadInterstitialAd() {
    if (!showInterstitialAd) return;

    InterstitialAd.load(
      adUnitId: "ca-app-pub-3118392277684870/9270340573", // actual
      // adUnitId: "ca-app-pub-3940256099942544/1033173712",  // tested

      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print("############################# Interstitial ad loaded.");
        },
        onAdFailedToLoad: (error) {
          print('################################# Interstitial failed to load: ${error.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Show the ad if available and hasn't been shown yet
  // void checkAndShowAdOnVisit() {
  //   if (!showInterstitialAd || _hasShownAd) return;
  //
  //   if (_interstitialAd != null) {
  //     _hasShownAd = true;
  //     _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (ad) {
  //         print("Interstitial ad dismissed.");
  //         _hasShownAd = false;
  //         loadInterstitialAd(); // Load next ad
  //       },
  //       onAdFailedToShowFullScreenContent: (ad, error) {
  //         print("Interstitial ad failed to show: ${error.message}");
  //         _hasShownAd = false;
  //         loadInterstitialAd(); // Try loading again
  //       },
  //     );
  //     _interstitialAd?.show();
  //     _interstitialAd = null;
  //   } else {
  //     print("Interstitial ad not ready, loading...");
  //     loadInterstitialAd(); // Load for next time
  //   }
  // }
  void checkAndShowAdOnVisit() {
    if (!showInterstitialAd) return;

    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print("Interstitial ad dismissed.");
          loadInterstitialAd(); // Load next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("Interstitial ad failed to show: ${error.message}");
          loadInterstitialAd(); // Try loading again
        },
      );
      _interstitialAd?.show();
      _interstitialAd = null; // Prevent re-showing same ad
    } else {
      print("Interstitial ad not ready, loading...");
      loadInterstitialAd(); // Load for next time
    }
  }

  /// Fetch config from Firebase Remote Config
  Future<void> fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setDefaults({
        'SplashInterstitial': true,
      });

      await remoteConfig.fetchAndActivate();

      showInterstitialAd = remoteConfig.getBool('SplashInterstitial');
      print('Remote config - showInterstitialAd: $showInterstitialAd');

      if (showInterstitialAd) {
        loadInterstitialAd();

      }

    } catch (e) {
      print('Remote Config fetch failed: $e');
      showInterstitialAd = true;
      loadInterstitialAd();
      fetchRemoteConfig();

    }
  }
}
