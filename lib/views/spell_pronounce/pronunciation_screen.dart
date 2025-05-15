// import 'dart:async';
// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity, ConnectivityResult;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:get/get.dart';
// import 'package:mnh/views/languages/provider/language_provider.dart';
// import 'package:mnh/widgets/copy_btn.dart';
// import 'package:mnh/widgets/delete_btn.dart';
// import 'package:mnh/widgets/extensions/empty_space.dart';
// import 'package:mnh/widgets/share_btn.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../ads_manager/interstitial_contrl.dart';
// import '../../ads_manager/native_as.dart';
// import '../../overlay_loader.dart';
// import '../../utils/app_icons.dart';
// import '../../utils/app_images.dart';
// import '../../widgets/back_button.dart';
// import '../../widgets/custom_textBtn.dart';
// import '../../widgets/text_widget.dart';
//
// class PronunciationScreen extends StatefulWidget {
//   const PronunciationScreen({super.key});
//
//   @override
//   State<PronunciationScreen> createState() => _PronunciationScreenState();
// }
//
// class _PronunciationScreenState extends State<PronunciationScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   final interstitialAdController = Get.put(InterstitialAdController());
//   final NativeAdController2 nativeAdController2 = Get.put(NativeAdController2());
//   Timer? _debounceTimer;
//   String _selectedValue = 'Eng';
//   bool _isLoading = false;
//   bool _showMic = true;
//
//   List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//   bool _isOnline = false;
//   bool _showAd = true; // Control the visibility of the ad
//
//   @override
//   void initState() {
//     super.initState();
//     _textController.addListener(_onTextChanged);
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
//     _checkInternetConnection();
//
//     interstitialAdController.showAd();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // nativeAdController.loadAd();
//     });
//   }
//
//   void _onTextChanged() {
//     if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
//
//     _debounceTimer = Timer(const Duration(seconds: 3), () {
//       _speak(); // Automatically speak the entered text after the timer expires
//     });
//   }
//
//   final Map<String, String> _languageCodes = {
//     'Eng': 'en',
//     'Spanish': 'es',
//     'Turkish': 'tr',
//     'Arabic': 'ar',
//     'Hindi': 'hi',
//   };
//
//   Future<void> _speak() async {
//     String textToSpeak = _textController.text.trim();
//     if (textToSpeak.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter text to read aloud.")),
//       );
//       return;
//     }
//
//     if (!_isOnline) {
//       _showNoConnectionDialog();
//       return;
//     }
//
//     String? languageCode = _languageCodes[_selectedValue];
//     if (languageCode != null) {
//       setState(() {
//         _isLoading = true; // Show loading overlay
//       });
//
//       String url = 'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=${Uri.encodeComponent(textToSpeak)}&tl=$languageCode';
//
//       // Play audio from the URL
//       await _audioPlayer.play(UrlSource(url));
//
//       // Hide loading overlay after playing
//       setState(() {
//         _isLoading = false;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Selected language is not supported.")),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     _audioPlayer.stop();
//     _connectivitySubscription.cancel();
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
//     setState(() {
//       _connectivityStatus = result;
//     });
//     _checkInternetConnection();
//   }
//
//   Future<void> _checkInternetConnection() async {
//     bool previousStatus = _isOnline;
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       _isOnline = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       _isOnline = false;
//     }
//
//     if (_isOnline != previousStatus) {
//       setState(() {});
//       if (!_isOnline) {
//         _showNoConnectionDialog();
//       }
//     }
//   }
//
//   void _showNoConnectionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return SimpleDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Column(
//                 spacing: 10,
//                 children: [
//                   Icon(Icons.wifi_off_outlined, color: Color(0XFF4169E1).withOpacity(0.76)),
//                   regularText(title: 'No Internet connection', textSize: 18, textColor: Colors.black, textWeight: FontWeight.w400),
//                   regularText(alignText: TextAlign.center, title: 'Please check your internet connection.', textSize: 16, textColor: Colors.black, textWeight: FontWeight.w200),
//                   Container(
//                     width: 100,
//                     height: 40,
//                     margin: EdgeInsets.symmetric(vertical: 8),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Color(0XFF4169E1).withOpacity(0.76),
//                     ),
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         _checkInternetConnection(); // Retry check on dialog dismiss
//                       },
//                       child: regularText(title: 'OK', textSize: 18, textColor: Colors.white, textWeight: FontWeight.w400),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void hideAd() {
//     setState(() {
//       _showAd = false; // Hide the ad when sharing
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final languageProvider = Provider.of<LanguageProvider>(context);
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.blueGrey.shade100,
//       appBar: AppBar(
//         backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
//         leading: CustomBackButton(
//           btnColor: Colors.white,
//           icon: Icons.arrow_back_ios,
//           iconSize: 24,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: regularText(
//           title: languageProvider.translate('Pronunciation'),
//           textSize: screenWidth * 0.056,
//           textColor: Colors.white,
//           textWeight: FontWeight.w500,
//         ),
//       ),
//       resizeToAvoidBottomInset: false,
//
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 spacing: screenWidth * 0.001,
//                 children: [
//                   Container(
//                     height: screenHeight * 0.4,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(12),
//                         bottomRight: Radius.circular(12),
//                       ),
//                       color: Colors.white,
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             6.asWidthBox,
//                             Image.asset(AppImages.UKFlag, scale: 22),
//                             6.asWidthBox,
//                             regularText(title: 'Eng', textSize: 16, textWeight: FontWeight.w400),
//                             Spacer(),
//                             CopyBtn(iconColor: Colors.black, controller: _textController),
//                             ShareBtn(
//                               iconColor: Colors.black,
//                               controller: _textController,
//                               onShare: hideAd, // Pass hideAd to ShareBtn
//                             ),
//                             DeleteBtn(iconColor: Colors.black, controller: _textController),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: TextFormField(
//                             maxLines: null,
//                             controller: _textController,
//                             decoration: InputDecoration(
//                               hintText: languageProvider.translate('Type here'),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         Spacer(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             _showMic ? GestureDetector(
//                               onTap: _speak,
//                               child: CMic2(textController: _textController),
//                             ) : CircularProgressIndicator(),
//                             7.asWidthBox,
//                             CustomTextBtn(
//                               height: screenHeight * 0.06,
//                               width: screenWidth * 0.52,
//                               textTitle: languageProvider.translate('Pronounce'),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
//                                 color: Color(0XFF4169E1).withOpacity(0.76),
//                               ),
//                               onTap: () {
//                                 _speak();
//                               },
//                             ),
//                           ],
//                         ),
//                         10.asHeightBox,
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_isLoading) LoadingOverlay(),
//
//             Container(
//               height: MediaQuery.of(context).size.height * 0.47,
//               margin: EdgeInsets.all(5),
//               child: _showAd && nativeAdController2.isAdReady
//                   ? nativeAdController2.adWidget.value // Show ad only if _showAd is true
//                   : Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: 150,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Your existing CMic2 class should remain unchanged

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity, ConnectivityResult;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:mnh/views/languages/provider/language_provider.dart';
import 'package:mnh/widgets/copy_btn.dart';
import 'package:mnh/widgets/delete_btn.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/share_btn.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../ads_manager/interstitial_contrl.dart';
import '../../ads_manager/native_as.dart';
import '../../ads_manager/openApp_controller.dart';
import '../../overlay_loader.dart';
import '../../utils/app_icons.dart';
import '../../utils/app_images.dart';
import '../../widgets/back_button.dart';
import '../../widgets/custom_textBtn.dart';
import '../../widgets/text_widget.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  final TextEditingController _textController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OpenAppAdController openAppAdController = Get.put(OpenAppAdController());
  final interstitialAdController = Get.put(InterstitialAdController());
  final NativeAdController nativeAdController = Get.put(NativeAdController());

  Timer? _debounceTimer;
  String _selectedValue = 'Eng';
  bool _isLoading = false;
  bool _showMic = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // For drawer detection

  List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = false;
  bool _showAd = true; // Control the visibility of the ad
  bool _isDrawerOpen = false;
  // bool _isAdVisible = true;
  bool _isInterstitialAdShowing = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();

    // Set callback for ad close
    interstitialAdController.onAdClosed = () {
      // When ad is closed, show the ad again
      setState(() {
        _showAd = true;
      });
      print("=========> Ad was closed, set _showAd to true");
    };

    interstitialAdController.showAd();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // nativeAdController.loadAd();
    });
  }

  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _speak(); // Automatically speak the entered text after the timer expires
    });
  }

  final Map<String, String> _languageCodes = {
    'Eng': 'en',
    'Spanish': 'es',
    'Turkish': 'tr',
    'Arabic': 'ar',
    'Hindi': 'hi',
  };

  Future<void> _speak() async {
    String textToSpeak = _textController.text.trim();
    if (textToSpeak.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter text to read aloud.")),
      );
      return;
    }

    if (!_isOnline) {
      _showNoConnectionDialog();
      return;
    }

    String? languageCode = _languageCodes[_selectedValue];
    if (languageCode != null) {
      setState(() {
        _isLoading = true; // Show loading overlay
      });

      String url = 'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=${Uri.encodeComponent(textToSpeak)}&tl=$languageCode';

      await _audioPlayer.play(UrlSource(url));

      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected language is not supported.")),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _audioPlayer.stop();
    _connectivitySubscription.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectivityStatus = result;
    });
    _checkInternetConnection();
  }
  bool _isAdVisible = true;
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
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Icon(Icons.wifi_off_outlined, color: Color(0XFF4169E1).withOpacity(0.76)),
                  regularText(title: 'No Internet connection', textSize: 18, textColor: Colors.black, textWeight: FontWeight.w400),
                  regularText(alignText: TextAlign.center, title: 'Please check your internet connection.', textSize: 16, textColor: Colors.black, textWeight: FontWeight.w200),
                  Container(
                    width: 100,
                    height: 40,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0XFF4169E1).withOpacity(0.76),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _checkInternetConnection(); // Retry check on dialog dismiss
                      },
                      child: regularText(title: 'OK', textSize: 18, textColor: Colors.white, textWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

void hideAD(){}

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Detect if keyboard is open
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // Check if interstitial ad is showing
    final isInterstitialShowing = interstitialAdController.showInterstitialAd;
    // Decide whether to show ad
    // final showAdWidget = _showAd && nativeAdController2.isAdReady && !isKeyboardOpen && !isInterstitialShowing;

    // Print detailed logs for debugging
    print("=========> isKeyboardOpen: $isKeyboardOpen");
    print("=========> isInterstitialShowing: $isInterstitialShowing");
    print("=========> _showAd: $_showAd");
    print("=========> nativeAdController2.isAdReady: ${nativeAdController.isAdReady}");

    // When keyboard is closed, show ad again if it was hidden
    if (!isKeyboardOpen && !_showAd) {
      setState(() {
        _showAd = true;
        print("=========> Keyboard closed, setting _showAd to true");
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
        leading: CustomBackButton(
          btnColor: Colors.white,
          icon: Icons.arrow_back_ios,
          iconSize: 24,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: regularText(
          title: languageProvider.translate('Pronunciation'),
          textSize: screenWidth * 0.056,
          textColor: Colors.white,
          textWeight: FontWeight.w500,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                spacing: screenWidth * 0.001,
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            6.asWidthBox,
                            Image.asset(AppImages.UKFlag, scale: 22),
                            6.asWidthBox,
                            regularText(title: 'Eng', textSize: 16, textWeight: FontWeight.w400),
                            Spacer(),
                            CopyBtn(iconColor: Colors.black, controller: _textController),
                            ShareBtn(
                              iconColor: Colors.black,
                              controller: _textController,
                              onShare: hideAD,
                            ),
                            DeleteBtn(iconColor: Colors.black, controller: _textController),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextFormField(
                            maxLines: null,
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: languageProvider.translate('Type here'),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _showMic
                                ? GestureDetector(
                              onTap: _speak,
                              child: CMic2(textController: _textController),
                            )
                                : CircularProgressIndicator(),
                            7.asWidthBox,
                            CustomTextBtn(
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.52,
                              textTitle: languageProvider.translate('Pronounce'),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: Color(0XFF4169E1).withOpacity(0.76),
                              ),
                              onTap: () {
                                _speak();
                              },
                            ),
                          ],
                        ),
                        10.asHeightBox,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) LoadingOverlay(),
            // Ad Widget Section
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              margin: EdgeInsets.all(5),
              child:  openAppAdController.adAlreadyShown || isKeyboardOpen
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
    );
  }
}

class CMic2 extends StatefulWidget {
  final TextEditingController textController;

  const CMic2({super.key, required this.textController});

  @override
  State<CMic2> createState() => _CMic2State();
}

class _CMic2State extends State<CMic2> {
  Color _containerColor = const Color(0XFF4169E1).withOpacity(0.76);
  Color _micColor = Colors.white; // Default mic color

  RxBool isListening = false.obs;
  static const MethodChannel _methodChannel = MethodChannel('com.example.mnh/speech_Text');

  Future<void> startSpeechToText(String languageISO) async {
    try {
      isListening.value = true;
      final result = await _methodChannel.invokeMethod('getTextFromSpeech', {'languageISO': languageISO});

      if (result != null && result.isNotEmpty) {
        widget.textController.text = result;
      }
    } on PlatformException catch (e) {
      print("Speech-to-text error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard

        // Change colors on tap
        setState(() {
          _containerColor = Colors.grey; // Container turns grey
          _micColor = Colors.blue; // Mic turns blue
        });

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _containerColor = const Color(0XFF4169E1).withOpacity(0.76); // Revert container color
            _micColor = Colors.white; // Revert mic color
          });
        });

        startSpeechToText('en-US');
      },
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.14,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          color: _containerColor, // Dynamic container color
        ),
        child: Image.asset(AppIcons.micIcon, color: _micColor, scale: 23), // Dynamic mic color
      ),
    );
  }
}

