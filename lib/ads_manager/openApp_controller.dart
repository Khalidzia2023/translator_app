import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mnh/ads_screen/ad_helper/ad_helper.dart';

class OpenAppAdController extends GetxController with WidgetsBindingObserver {
  AppOpenAd? openAd;
  bool _isFromBackground = false;  // Track background state
  bool adAlreadyShown = false;  // Prevent showing ad multiple times

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isFromBackground) {
        _isFromBackground = false;  // Reset background flag

        if (!adAlreadyShown && openAd != null) {
          adAlreadyShown = true;
          openAd?.show();
          openAd = null;  // Dispose after showing
          loadAd();  // Preload next ad
        }
      }
    } else if (state == AppLifecycleState.paused) {
      _isFromBackground = true;  // Mark app as backgrounded
      adAlreadyShown = false;
    }
  }

  void loadAd() {
    AppOpenAd.load(
      // adUnitId: 'ca-app-pub-3940256099942544/9257395921',
      adUnitId: 'ca-app-pub-3118392277684870/2648691551',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          openAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Open App Ad failed to load: $error');
        },
      ),
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    openAd?.dispose();
    super.onClose();
  }
}


