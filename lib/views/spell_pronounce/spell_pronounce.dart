import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mnh/ads_manager/native_as.dart';
import 'package:mnh/ads_manager/openApp_controller.dart';
import 'package:mnh/utils/app_colors.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/spell_pronounce/check_spell.dart';
import 'package:mnh/views/spell_pronounce/dictionary.dart';
import 'package:mnh/views/spell_pronounce/phases.dart';
import 'package:mnh/views/spell_pronounce/pronunciation_screen.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ads_manager/interstitial_contrl.dart';
import '../../tts_service2.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/text_widget.dart';
import 'package:mnh/views/languages/provider/language_provider.dart';
import '../speak2_screen.dart';

class SpellPronounce extends StatefulWidget {
  const SpellPronounce({super.key});

  @override
  State<SpellPronounce> createState() => _SpellPronounceState();
}

class _SpellPronounceState extends State<SpellPronounce> {
  bool _hasDialogBeenShown = false;

  // Track visibility of ads
  bool _isAdVisible = true;
  bool _isDrawerOpen = false;

  // Track if interstitial is showing
  bool _isInterstitialAdShowing = false;

  final List<String> titleKeys = [
    'Spell Check',
    'Translation',
    'Dictionary',
    'Phrases',
  ];

  final List<Widget> screens = [
    CheckSpellScreen(),
    TranslatorScreen(),
    DictionaryHomePage(),
    PhrasesScreen(),
  ];

  final List<double> iconSize = [14, 14.2, 14.2, 14.7];

  final List<String> icons = [
    AppIcons.spelIcon1,
    AppIcons.transIcon1,
    AppIcons.dictnIcon1,
    AppIcons.phrsIcon1,
  ];

  final List<Color> tileColor = [
    Color(0XFF6082B6),
    Color(0XFF6082B6),
    Color(0XFF6082B6),
    Color(0XFF6082B6),
  ];

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = false;

  // Ad controllers
  final NativeAdController nativeAdController = Get.put(NativeAdController());
  final InterstitialAdController interstitialAdManager = Get.put(InterstitialAdController());
  final OpenAppAdController openAppAdController = Get.put(OpenAppAdController());

  @override
  void initState() {
    super.initState();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();

    // Listen to interstitial ad events
    interstitialAdManager.onAdClosed = () {
      setState(() {
        _isInterstitialAdShowing = false;
      });
    };

    // For example, show ad at certain event
    // e.g., on button press, or after some time
    // Here, just for demo, say after 10 sec
    Future.delayed(Duration(seconds: 10), () {
      _showInterstitialAd();
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isTap = false;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _onDrawerChanged(bool isOpen) {
    setState(() {
      _isDrawerOpen = isOpen;
    });
    nativeAdController.adWidget.value;
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    bool previousStatus = _isOnline;
    try {
      final result = await InternetAddress.lookup('google.com');
      _isOnline = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _isOnline = false;
    }

    if (_isOnline != previousStatus) {
      setState(() {});
      if (!_isOnline) {
        _showNoConnectionDialog();
      }
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkInternetConnection();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  void rateUs() async {
    final Uri playStoreUri =
    Uri.parse("market://details?id=com.ma.spellpronuciationexpert");
    if (!await launchUrl(playStoreUri, mode: LaunchMode.externalApplication)) {
      final Uri fallbackUri = Uri.parse(
          "https://play.google.com/store/apps/details?id=com.ma.spellpronuciationexpert");
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> exact() async {
    if (_hasDialogBeenShown) return;

    _hasDialogBeenShown = true;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(Icons.exit_to_app_outlined, color: Colors.orange, size: 40),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: regularText(
                title: 'Do you want to exit the app or rate us?',
                textColor: Colors.black,
                textSize: 16,
                textWeight: FontWeight.w600,
                alignText: TextAlign.center),
          ),
          actions: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey)),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    rateUs();
                    _hasDialogBeenShown = false;
                  },
                  child: regularText(
                      title: 'Rate Us',
                      textColor: Colors.white,
                      textSize: 14,
                      textWeight: FontWeight.w600)),
            ),
            SizedBox(width: 40),
            Container(
              width: 100,
              decoration: BoxDecoration(
                  color: Color(0XFF4169E1).withOpacity(0.76),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey)),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _hasDialogBeenShown = false;
                },
                child: const Text("Exit", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    ) ?? false;

    _hasDialogBeenShown = false;

    if (shouldExit) {
      SystemNavigator.pop();
    }
  }

  bool isTap = true;

  void _showInterstitialAd() {
    setState(() {
      _isInterstitialAdShowing = true;
    });
    interstitialAdManager.showAd();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Determine whether to show native ad or placeholder
    bool showNativeAd = _isAdVisible && !_isDrawerOpen && !_isInterstitialAdShowing;
    // When interstitial, open app ad, or drawer is open, show SizedBox
    // Otherwise, show the ad if ready, or shimmer if not
    Widget adWidget;
    if (!showNativeAd) {
      adWidget = SizedBox();
    } else {
      adWidget = nativeAdController.isAdReady
          ? nativeAdController.adWidget.value
          : Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await exact();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        onDrawerChanged: (isOpen) {
          _onDrawerChanged(isOpen);
        },
        backgroundColor: AppColors.kWhiteEF,
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu, size: 30),
                onPressed: () {
                  setState(() {
                    _isAdVisible = false; // hide ads when opening drawer
                  });
                  _scaffoldKey.currentState?.openDrawer();
                },
              );
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
          title: regularText(
            title: languageProvider.translate('Spell & Pronounce '),
            textSize: screenWidth * 0.056,
            textColor: Colors.white,
            textWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Your top container...
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border(bottom: BorderSide(color: AppColors.kWhite, width: 2)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PronunciationScreen()));
                      },
                      child: AnimatedContainer(
                        alignment: Alignment.centerLeft,
                        duration: Duration(seconds: 2),
                        curve: Curves.easeInOut,
                        height: screenHeight * 0.08,
                        width: isTap ? screenWidth * 0.62 : screenWidth * 0.92,
                        decoration: BoxDecoration(
                          color: Color(0XFF4169E1).withOpacity(0.76),
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcons.pronIcon1,
                              scale: screenWidth * 0.06,
                              color: Colors.white,
                            ),
                            SizedBox(width: 14),
                            regularText(
                              title: languageProvider.translate('Pronunciation'),
                              textSize: screenWidth * 0.054,
                              textColor: Colors.white,
                              textWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01,
                            vertical: screenHeight * 0.012),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 12 / 8,
                          mainAxisSpacing: screenWidth * 0.03,
                          crossAxisSpacing: screenWidth * 0.03,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => screens[index]));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFF4169E1).withOpacity(0.76),
                                borderRadius:
                                BorderRadius.circular(screenWidth * 0.034),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    icons[index],
                                    color: Colors.white,
                                    scale: iconSize[index],
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      print(
                                          "Error loading asset: ${icons[index]}");
                                      return Icon(Icons.error, color: Colors.red);
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: regularText(
                                      title: languageProvider
                                          .translate(titleKeys[index]),
                                      textSize: screenWidth * 0.052,
                                      textColor: Colors.white,
                                      textWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Native ad section (with conditional display)
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                margin: EdgeInsets.all(5),
                child: _isDrawerOpen || openAppAdController.adAlreadyShown
                    ? SizedBox()
                    : Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  margin: EdgeInsets.all(5),
                  child: _isAdVisible && nativeAdController.isAdReady
                      ? nativeAdController.adWidget.value
                      : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),

      ),
    );
  }
}