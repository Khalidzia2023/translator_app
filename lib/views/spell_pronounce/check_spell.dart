import 'dart:async';
import 'dart:io';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:fluttertoast/fluttertoast.dart'; // For Toast messages
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';
import 'package:mnh/ads_manager/interstitial_contrl.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../ads_manager/native_as.dart';
import '../../ads_manager/openApp_controller.dart';
import '../../utils/app_icons.dart';
import '../../utils/app_images.dart';
import '../../widgets/back_button.dart';
import '../../widgets/copy_btn.dart';
import '../../widgets/custom_textBtn.dart';
import '../../widgets/delete_btn.dart';
import '../../widgets/share_btn.dart';
import '../../widgets/text_widget.dart';
import '../languages/provider/language_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity, ConnectivityResult;

class CheckSpellScreen extends StatefulWidget {
  const CheckSpellScreen({super.key});

  @override
  State<CheckSpellScreen> createState() => _CheckSpellScreenState();
}

class _CheckSpellScreenState extends State<CheckSpellScreen> {
  final TextEditingController _textController = TextEditingController();
  final LanguageToolController _controller = LanguageToolController();
  final interstitialAdController = Get.put(InterstitialAdController());
  final OpenAppAdController openAppAdController = Get.put(OpenAppAdController());
  final NativeAdController nativeAdController = Get.put(NativeAdController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // For drawer detection
  bool _showAd = true;
  bool _isAdVisible = true;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = false;
  Color _buttonColor = Color(0XFF4169E1).withOpacity(0.76);
  Color copyColor = Colors.grey;
  Color deleteColor = Colors.grey;
  Color shareColor = Colors.grey;
// Control the visibility of the ad

  // Function to change color temporarily for 2 seconds
  void changeColor(String action) {
    setState(() {
      if (action == 'copy') {
        copyColor = Colors.blue;
      } else if (action == 'delete') {
        deleteColor = Colors.blue;
      } else if (action == 'share') {
        shareColor = Colors.blue;
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        if (action == 'copy') {
          copyColor = Colors.grey;
        } else if (action == 'delete') {
          deleteColor = Colors.grey;
        } else if (action == 'share') {
          shareColor = Colors.grey;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    interstitialAdController.onAdClosed = () {
      // When ad is closed, show the ad again
      setState(() {
        _showAd = true;
      });
      print("=========> Ad was closed, set _showAd to true");
    };
    interstitialAdController.showAd();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flutterTts.setLanguage('en-US');
    });
  }

  List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = false;

  final Map<String, Map<String, String>> languageCountryCode = {
    "English": {"code": "US", "country": "United States"},
    "Afrikaans": {"code": "ZA", "country": "South Africa"},
    "Albanian": {"code": "AL", "country": "Albania"},
  };
  bool _isCooldown = false;
  bool _isTextAvailable = false;
  void hideAd() {
    setState(() {
      _showAd = false; // Hide the ad when sharing
    });
    print("=========> hideAd called, _showAd set to false");
  }
  // Define _performSpellCheck method
  Future<void> _performSpellCheck() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    String inputText = _controller.text.trim();
    String correctedText = inputText;

    if (inputText.isEmpty) {
      Fluttertoast.showToast(msg: languageProvider.translate('Please enter the text'));
    } else {
      // Fluttertoast.showToast(msg: languageProvider.translate('spelling check completed, wrong spellings are highlighted'));
    }

    setState(() {
      _isLoading = true;
      _controller.text = correctedText;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    _flutterTts.stop();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectivityStatus = result;
    });
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
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                spacing: 10,
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


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // Check if interstitial ad is showing
    final isInterstitialShowing = interstitialAdController.showInterstitialAd;


    final showAdWidget = _showAd && nativeAdController.isAdReady && !isKeyboardOpen && !isInterstitialShowing;

    // Print detailed logs for debugging
    print("=========> isKeyboardOpen: $isKeyboardOpen");
    print("=========> isInterstitialShowing: $isInterstitialShowing");
    print("=========> _showAd: $_showAd");

    print("=========> showAdWidget: $showAdWidget");
    print("=========> Ad is ${showAdWidget ? 'SHOWING' : 'HIDDEN'}");
    print("=========> Keyboard and ad status: Keyboard is ${isKeyboardOpen ? 'open' : 'closed'}, Ad is ${showAdWidget ? 'showing' : 'hidden'}");

    // When keyboard is closed, show ad again if it was hidden
    if (!isKeyboardOpen && !_showAd) {
      setState(() {
        _showAd = true;
        print("=========> Keyboard closed, setting _showAd to true");
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
        leading: CustomBackButton(
          iconSize: 24,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icons.arrow_back_ios_outlined,
          btnColor: Colors.white,
        ),
        centerTitle: true,
        title: regularText(
          title: languageProvider.translate('Spell Check'),
          textColor: Colors.white,
          textWeight: FontWeight.w500,
          textSize: screenWidth * 0.056,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.38,
              width: screenWidth * 0.98,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LanguageContainer(
                        language: 'English',
                        countryCode: languageCountryCode['English']!['code']!,
                      ),
                      Spacer(),
                      CopyBtn(iconColor: Colors.black, controller: _controller),
                      ShareBtn(
                        iconColor: Colors.black,
                        controller: _controller,
                        onShare: hideAd, // Pass the hideAd method to ShareBtn
                      ),
                      DeleteBtn(iconColor: Colors.black, controller: _controller),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        LanguageToolTextField(
                          mistakePopup: MistakePopup(
                            popupRenderer: PopupOverlayRenderer(),
                            mistakeBuilder: ({
                              required controller,
                              required mistake,
                              required mistakePosition,
                              required popupRenderer,
                            }) {
                              return Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  border: Border(bottom: BorderSide(color: Colors.grey)),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                height: 280, // Adjust height based on content
                                width: 170,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Suggestions',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
                                    ),
                                    Divider(thickness: 2, color: Colors.white),
                                    SizedBox(height: 5),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: mistake.replacements.length,
                                        itemBuilder: (context, index) {
                                          final suggestion = mistake.replacements[index];
                                          return GestureDetector(
                                            onTap: () {
                                              controller.replaceMistake(mistake, suggestion);
                                              controller.text = controller.text; // Refresh UI
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: SizedBox(
                                                height: 30,
                                                child: Text(
                                                  '$suggestion ',
                                                  style: TextStyle(color: Colors.black, fontSize: 19),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          focusNode: FocusNode(),
                          controller: _controller,
                          language: 'en-US',
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: languageProvider.translate('Type your text here...'),
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CuMic2(textController: _controller),
                      7.asWidthBox,
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomTextBtn(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.52,
                        textTitle: languageProvider.translate('Spell Check'),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          color: _buttonColor, // Use a variable for dynamic color
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus(); // Hide keyboard

                          setState(() {
                            _buttonColor = Colors.grey; // Change to grey
                          });

                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _buttonColor = Color(0XFF4169E1).withOpacity(0.76); // Revert to original
                            });
                          });

                          // interstitialAdController.checkAndShowAdOnVisit();
                          if (!_isOnline) {
                            _showNoConnectionDialog();
                            return;
                          }
                          _performSpellCheck();
                        },
                      ),
                    ],
                  ),
                  10.asHeightBox,
                ],
              ),
            ),
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

class LanguageContainer extends StatelessWidget {
  final String language;
  final String countryCode;

  const LanguageContainer({required this.language, required this.countryCode});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String displayLanguage = language.length > 8 ? '${language.substring(0, 8)}...' : language;

    return SizedBox(
      height: screenHeight * 0.07,
      width: screenWidth * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 6),
          CountryFlag.fromCountryCode(
            countryCode,
            height: 24,
            width: 24,
            shape: Circle(),
          ),
          Text(
            displayLanguage,
            style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.044),
          ),
        ],
      ),
    );
  }
}

class CuMic2 extends StatefulWidget {
  final TextEditingController textController;

  const CuMic2({super.key, required this.textController});

  @override
  State<CuMic2> createState() => _CuMic2State();
}

class _CuMic2State extends State<CuMic2> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isCooldown = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print("Speech Status: $status");
      },
      onError: (error) {
        print("Speech Error: $error");
      },
    );
    if (!available) {
      Get.snackbar("Error", "Speech recognition is not available.");
    }
  }

  Future<void> _startListening(String languageCode) async {
    if (_isCooldown || _isListening) return;

    setState(() {
      _isListening = true;
      _isCooldown = true;
    });

    try {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            widget.textController.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 10),
        cancelOnError: true,
      );
    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isListening = false;
        _isCooldown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        _startListening('en-US');
      },
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.14,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          color: const Color(0XFF4169E1).withOpacity(0.76),
        ),
        child: Image.asset(AppIcons.micIcon, color: Colors.white, scale: 23),
      ),
    );
  }
}