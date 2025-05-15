import 'dart:ui';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  int clickCount = 0;
  bool showInterstitialAd = true; // Controlled via Remote Config

  // Callback to notify when ad is closed
  VoidCallback? onAdClosed;

  @override
  void onInit() {
    super.onInit();
    loadInterstitialAd();
  }

  // Load a new ad
  void loadInterstitialAd() {
    if (!showInterstitialAd) return;
    InterstitialAd.load(

        adUnitId: "ca-app-pub-3118392277684870/3961773221" ,// actual ad unit ID
        // adUnitId: "ca-app-pub-3940256099942544/1033173712", // test ad
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial failed to load: ${error.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  // Show ad only every third click
  void showAd() {
    clickCount++;

    if (clickCount % 3 == 0 && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('Interstitial ad dismissed.');
          _interstitialAd = null;
          loadInterstitialAd(); // Load next ad
          if (onAdClosed != null) {
            onAdClosed!(); // Notify when ad is closed
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Failed to show interstitial ad: ${error.message}');
          _interstitialAd = null;
          loadInterstitialAd(); // Load next ad
          if (onAdClosed != null) {
            onAdClosed!(); // Notify even if failed
          }
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null; // Clear reference after showing
    } else if (clickCount % 3 == 0) {
      print('Ad should be shown but not loaded. Reloading...');
      loadInterstitialAd();
    } else {
      print('Click $clickCount: Ad not shown this time.');
    }
  }
}
