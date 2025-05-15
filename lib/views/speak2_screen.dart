import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:mnh/views/languages/provider/language_provider.dart';
import 'package:mnh/translator/controller/translate_contrl.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/app_icons.dart';
import '../../widgets/back_button.dart';
import '../../widgets/custom_textBtn.dart';
import '../../widgets/text_widget.dart';
import '../ads_manager/banner_cnrtl.dart';
import '../ads_manager/interstitial_contrl.dart';
import '../ads_manager/native_as.dart';
import '../ads_manager/openApp_controller.dart';
import '../controller/slider_controller.dart';
import '../overlay_loader.dart';
import '../testScreen.dart';
import '../tts_service.dart';
import '../widgets/custom_mic.dart';
import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity, ConnectivityResult;

class LanguageSelectionWidget extends StatefulWidget {
  final String currentLang;
  final void Function(String?) onLangSelect;
  final bool isFirstContainer;

  const LanguageSelectionWidget({
    required this.currentLang,
    required this.onLangSelect,
    required this.isFirstContainer,
  });

  @override
  _LanguageSelectionWidgetState createState() => _LanguageSelectionWidgetState();
}

class _LanguageSelectionWidgetState extends State<LanguageSelectionWidget> {
  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();
  bool _isTranslate = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {}); // Trigger a rebuild when the keyboard is dismissed
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final MyTranslationController MytranslationController = Get.put(MyTranslationController());

    final TtsService ttsService = TtsService();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              languageProvider.translate('Select the language you want'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: languageProvider.translate('Search languages...'),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: MytranslationController.languageCodes.length,
                itemBuilder: (context, index) {
                  String language = MytranslationController.languageFlags.keys.elementAt(index);
                  String code = MytranslationController.languageFlags[language] ?? '';

                  if (language.toLowerCase().contains(searchQuery)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: ListTile(
                          tileColor: Colors.grey.shade200,
                          title: Text(language, style: const TextStyle(fontSize: 16)),
                          dense: true,
                          leading: CountryFlag.fromCountryCode(
                            code,
                            height: 25,
                            shape: Circle(),
                          ),
                          trailing: widget.currentLang == language
                              ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                              : null,
                          onTap: () async {
                            ttsService.stop();

                            widget.onLangSelect(language);

                            if (widget.isFirstContainer) {
                              MytranslationController.controller.clear();
                              setState(() {
                                _isTranslate = true;
                              });
                            } else {
                              String originalText = MytranslationController.controller.text;
                              if (originalText.isNotEmpty) {
                                String? translatedText = await MytranslationController.translate(originalText);
                                if (translatedText != null && translatedText.isNotEmpty) {
                                  MytranslationController.translatedText.value = translatedText;
                                } else {
                                  Get.snackbar('Error', 'Translation failed. Please try again.');
                                }
                              }
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container if no matches
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class THistoryBtn extends StatefulWidget {
  const THistoryBtn({
    super.key,
    required this.translationHistory,
    required this.onDelete,
  });

  final List<Map<String, String>> translationHistory;
  final Function(int) onDelete;

  @override
  _THistoryBtnState createState() => _THistoryBtnState();
}

class _THistoryBtnState extends State<THistoryBtn> {
  final TtsService ttsService = TtsService();
  List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final SliderController sliderController = Get.put(SliderController());
  bool _isOnline = false;


  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();
  }

  @override
  void dispose() {
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
                  Icon(Icons.wifi_off_outlined, color: Color(0XFF4169E1).withOpacity(0.76),),
                  regularText(title: 'No Internet connection', textSize: 18, textColor: Colors.black, textWeight: FontWeight.w400),
                  regularText(alignText: TextAlign.center, title: 'Please check your internet connection.', textSize: 16, textColor: Colors.black, textWeight: FontWeight.w200),
                  Container(
                    width: 100, height: 40,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0XFF4169E1).withOpacity(0.76),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _checkInternetConnection();
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
    final MyTranslationController myTranslationController = Get.put(MyTranslationController());
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0XFF4169E1).withOpacity(0.76),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.history,
          color: Colors.white,
        ),
        onPressed: () {
          ttsService.stop;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: .6,
                                spreadRadius: 1.2,
                                offset: Offset(1.2, 2.4)
                            )
                          ]
                      ),
                      child: Center(
                        child: Text(
                          'Translations History',
                          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.translationHistory.length,
                        itemBuilder: (context, index) {
                          final item = widget.translationHistory[index];
                          final fromLanguage = item['fromLanguage'] ?? '';
                          final toLanguage = item['toLanguage'] ?? '';
                          final originalText = item['original'] ?? '';
                          final translatedText = item['translated'] ?? '';

                          final isOriginalRTL = myTranslationController.isRTLLanguage(fromLanguage);
                          final isTranslatedRTL = myTranslationController.isRTLLanguage(toLanguage);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Column(
                              children: [
                                _buildLanguageSection(
                                  language: fromLanguage,
                                  text: originalText,
                                  isRTL: isOriginalRTL,
                                  isTranslated: false,
                                  myTranslationController: myTranslationController,
                                ),
                                _buildLanguageSection(
                                  language: toLanguage,
                                  text: translatedText,
                                  isRTL: isTranslatedRTL,
                                  isTranslated: true,
                                  myTranslationController: myTranslationController,
                                  onSpeak: () {

                                    String languageCode = myTranslationController.languageCodes[toLanguage]!;
                                    ttsService.speakText(translatedText, languageCode, sliderController.speechSlider, sliderController.pitchSlider);
                                  },
                                  onDelete: () {
                                    widget.onDelete(index); // Call the delete callback
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ).whenComplete(() {
            ttsService.stop();
          });
        },
      ),
    );
  }

  Widget _buildLanguageSection({
    required String language,
    required String text,
    required bool isRTL,
    required bool isTranslated,
    required MyTranslationController myTranslationController,
    void Function()? onSpeak,
    void Function()? onDelete,
  }) {
    final backgroundColor = isTranslated
        ? const Color(0xFF4169E1).withOpacity(0.76)
        : Colors.white;

    final textColor = isTranslated ? Colors.white : Colors.black;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTranslated ? 0 : 10),
          topRight: Radius.circular(isTranslated ? 0 : 10),
          bottomLeft: Radius.circular(isTranslated ? 10 : 0),
          bottomRight: Radius.circular(isTranslated ? 10 : 0),
        ),
        border: isTranslated
            ? null
            : Border(top: BorderSide(color: Colors.blueGrey.shade100, width: 2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                CountryFlag.fromCountryCode(
                  myTranslationController.languageFlags[language] ?? '',
                  height: 26,
                  width: 26,
                  shape: Circle(),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 170,
                  child: Text(
                    language,
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            if (isTranslated)
              Row(
                mainAxisAlignment: isRTL ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: isRTL ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        ttsService.stop(); // Call the stop method properly
                        onSpeak?.call(); // Call the function safely
                        if (!_isOnline) {
                          _showNoConnectionDialog();
                          return;
                        }
                      },

                    ),
                  ),
                  SizedBox(width: 7,),
                  GestureDetector(
                    onTap: () {
                      ttsService.stop();
                      Clipboard.setData(ClipboardData(text: text));
                    },
                    child: Image.asset(
                        AppIcons.copyIcon,
                        scale: 26,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(width: 7,),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class SelectedLangShow extends StatelessWidget {
  final String language;
  final String countryCode;
  final Color containerColor;
  final Color? LangColor;

  const SelectedLangShow({
    required this.language,
    required this.countryCode,
    required this.containerColor,
    this.LangColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth  = MediaQuery.of(context).size.width;
    String displayLanguage = language.length > 8 ? '${language.substring(0, 8)}...' : language;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: containerColor
      ),
      child: Row(
        spacing: 10,
        children: [
          // 2.asWidthBox,
          CountryFlag.fromCountryCode(
            countryCode,
            height: 20,
            width: 20,
            shape: Circle(),
          ),
          Text(
            language,
            style: TextStyle(color: LangColor ?? Colors.white, fontSize: screenWidth * 0.046),
          ),
        ],
      ),
    );
  }
}
class LanguageContainer extends StatelessWidget {
  final String language;
  final String countryCode;
  final Color containerColor;

  const LanguageContainer({
    required this.language,
    required this.countryCode,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth  = MediaQuery.of(context).size.width;
    String displayLanguage = language.length > 7 ? '${language.substring(0, 7)}...' : language;
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.42,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: containerColor
      ),
      child: Row(
        spacing: 3,
        children: [
          4.asWidthBox,
          CountryFlag.fromCountryCode(
            countryCode,
            height: 26,
            width: 26,
            shape: Circle(),
          ),
          Text(
            displayLanguage,
            style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.042),
          ),
          Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
        ],
      ),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final MyTranslationController MytranslationController = Get.put(MyTranslationController());
  final SliderController sliderController = Get.put(SliderController());
  final ScrollController _scrollController = ScrollController();
  final TtsService ttsService = TtsService();
  final TtsServiceTest _ttsService = TtsServiceTest();

  final OpenAppAdController openAppAdController = Get.put(OpenAppAdController());
  final InterstitialAdController interstitialAdController = Get.put(InterstitialAdController());
  final BannerAdController bannerAdController = Get.put(BannerAdController());
  // 
  bool _showAd = true;
  bool _isTranslate = true;
  List<Map<String, String>> translationHistory = [];
  bool _isLoadingMic = false;
  Timer? _debounceTimer;
  bool _isLoadingTranslate = false;
  List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = false;
  bool hasTranslation = true;
  double _pitchSlider = 1.0;
  double _speechSlider = 1.0;
  bool swapTap = true;

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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                spacing: 10,
                children: [
                  Icon(Icons.wifi_off_outlined, color: Color(0XFF4169E1).withOpacity(0.76),),
                  regularText(
                      title: 'No Internet connection',
                      textSize: 18, textColor: Colors.black, textWeight: FontWeight.w400),
                  regularText(
                      alignText: TextAlign.center,
                      title: 'Please check your internet connection.', textSize: 16,
                      textColor: Colors.black, textWeight: FontWeight.w200),
                  Container(
                    width: 100, height: 40,
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


  Future<void> handleSpeechToText(String languageCode) async {
    if (_isLoadingMic) {
      Fluttertoast.showToast(
        msg: "You tapped more than once. Please wait a moment.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    try {
      setState(() {
        _isLoadingMic = true;
      });

      // Start debounce timer when mic is pressed
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds:1), () async {
        await MytranslationController.startSpeechToText(languageCode);

        // After speech recognition, translate and speak
        String originalText = MytranslationController.controller.text;
        if (originalText.isNotEmpty) {
          String? translatedText = await MytranslationController.translate(originalText);
          if (translatedText != null && translatedText.isNotEmpty) {
            MytranslationController.translatedText.value = translatedText;
            addToHistory(originalText, translatedText);

            // Speak the translated text
            String languageCode = MytranslationController.languageCodes[
            MytranslationController.secondContainerLanguage.value] ?? 'ko';
            await ttsService.speakText(
                translatedText,
                languageCode,
                sliderController.speechSlider,
                sliderController.pitchSlider
            );
          }
        }
      });

    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
    } finally {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        _isLoadingMic = false;
      });
    }
  }
  Future<void> speakText(String text, String languageCode) async {
    await ttsService.stop(); // Stop any ongoing speech before speaking
    await ttsService.speakText(text, languageCode, _speechSlider, _pitchSlider); // Use TtsService for speaking
  }

  void _showLanguageSelect({
    required String currentLang,
    required void Function(String?) onLangSelect,
    required bool isFirstContainer,
  }) {
    ttsService.stop(); // Stop ongoing TTS before showing language selection
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LanguageSelectionWidget(
          currentLang: currentLang,
          onLangSelect: (selected) {
            if (selected != null) {
              setState(() {
                if (isFirstContainer) {
                  MytranslationController.firstContainerLanguage.value = selected;
                } else {
                  MytranslationController.secondContainerLanguage.value = selected;
                  saveSelectedLanguageToPreferences(selected); // Save second container language
                }
                MytranslationController.controller.clear();
                MytranslationController.translatedText.value = '';
              });
            }
          },
          isFirstContainer: isFirstContainer,
        );
      },
    );
  }
  Future<void> saveHistoryToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String historyJson = jsonEncode(translationHistory);
    await prefs.setString('translationHistory', historyJson);
  }

  Future<void> loadHistoryFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('translationHistory');

    if (historyJson != null) {
      List<dynamic> decodedHistory = jsonDecode(historyJson);
      setState(() {
        translationHistory = List<Map<String, String>>.from(decodedHistory.map((item) => Map<String, String>.from(item)));
      });
    }
  }
  Future<void> saveSelectedLanguageToPreferences(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('secondContainerLanguage', language);
  }

  void addToHistory(String originalText, String translatedText) {
    if (originalText.isNotEmpty && translatedText.isNotEmpty) {
      if (translationHistory.isEmpty ||
          (translationHistory.isNotEmpty &&
              (translationHistory.first['original'] != originalText ||
                  translationHistory.first['translated'] != translatedText))) {
        setState(() {
          translationHistory.insert(0, {
            'original': originalText,
            'translated': translatedText,
            'fromLanguage': MytranslationController.firstContainerLanguage.value,
            'toLanguage': MytranslationController.secondContainerLanguage.value,
          });

          if (translationHistory.length > 6) {
            translationHistory.removeRange(6, translationHistory.length);
          }
          saveHistoryToSharedPreferences(); // Save history whenever a new entry is added
        });
      }
    }
  }
  Future<void> loadHistoryAndLanguagesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load translation history
    final String? historyJson = prefs.getString('translationHistory');
    if (historyJson != null) {
      List<dynamic> historyList = jsonDecode(historyJson);
      setState(() {
        translationHistory = List<Map<String, String>>.from(historyList.map((item) => Map<String, String>.from(item)));
      });
    }

    // Load second container language
    final String? savedLanguage = prefs.getString('secondContainerLanguage');
    if (savedLanguage != null) {
      MytranslationController.secondContainerLanguage.value = savedLanguage;
    }
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    // MytranslationController.controller.addListener(_onTextChanged);
    loadHistoryAndLanguagesFromSharedPreferences();
    loadHistoryFromSharedPreferences();
    // bannerAdController.loadBannerAd3('large');

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();
    interstitialAdController.onAdClosed = () {
      // When ad is closed, show the ad again
      setState(() {
        _showAd = true;
      });
      print("=========> Ad was closed, set _showAd to true");
    };

    interstitialAdController.showAd();

  }
  bool _isCooldown = false;
  bool _isTextAvailable = false;

  void hideAd() {
    setState(() {
      _showAd = false; // Hide the ad when sharing
    });
    print("=========> hideAd called, _showAd set to false");
  }
  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _debounceTimer?.cancel();
    // MytranslationController.controller.removeListener(_onTextChanged);
    ttsService.stop();
    ttsService.dispose();
    _ttsService.dispose();
    _scrollController.dispose();

    _connectivitySubscription.cancel();
    Get.delete<MyTranslationController>();
    super.dispose();
  }
  void _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();

    }
    _debounceTimer = Timer(const Duration(seconds:1), () {
      _translateAndSpeak();
    });
  }
  Future<void> _translateAndSpeak() async {
    String originalText = MytranslationController.controller.text.trim();

    if (originalText.isNotEmpty) {
      if (!_isOnline) {
        _showNoConnectionDialog();
        return;
      }
      String? translatedText = await MytranslationController.translate(originalText);
      String languageCode = MytranslationController.languageCodes[MytranslationController.secondContainerLanguage.value] ?? 'ko'; // Default to Korean

      await ttsService.speakText(translatedText!, languageCode, sliderController.speechSlider, sliderController.pitchSlider);

    }
  }
  bool _isAdVisible = true;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // Check if interstitial ad is showing
    final isInterstitialShowing = interstitialAdController.showInterstitialAd;

    final showAdWidget = _showAd && bannerAdController.isAdReady('ad1') && !isKeyboardOpen && !isInterstitialShowing;

    // final showAdWidget = _showAd && bannerAdController.isAdReady && !isKeyboardOpen && !isInterstitialShowing;

    // Print detailed logs for debugging
    print("=========> isKeyboardOpen: $isKeyboardOpen");
    print("=========> isInterstitialShowing: $isInterstitialShowing");
    print("=========> _showAd: $_showAd");
    print("=========> nativeAdController2.isAdReady: ${bannerAdController.isAdReady('ad1') }");
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
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Color(0XFFE8E8E8),
        bottomNavigationBar: openAppAdController.adAlreadyShown || isKeyboardOpen
                              ? SizedBox()
                              : _isAdVisible && bannerAdController.isAdReady('ad1')
                              ? bannerAdController.getBannerAdWidget5('ad1')
                              : Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        appBar: AppBar(
          backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
          leading: CustomBackButton(
            btnColor: Colors.white,
            icon: Icons.arrow_back_ios,
            iconSize: screenWidth * 0.06,
            onPressed: () {
              swapTap == false;
              ttsService.stop();
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: regularText(
            title: languageProvider.translate('Translate language'),
            textColor: Colors.white,
            textSize: screenWidth * 0.056,
            textWeight: FontWeight.w500,
          ),
          actions: [

            IconButton(
              onPressed: () {
                ttsService.stop();
                final sliderController = Get.find<SliderController>(); // Ensure you get the instance correctly
                sliderController.showSliderDialog(context);
              },
              icon: Icon(Icons.equalizer_sharp, color: Colors.white),
            ),
            SizedBox(width: 10,)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // First language container
                    GestureDetector(
                      onTap: () {
                        swapTap == false;
                        _showLanguageSelect(
                          currentLang: MytranslationController.firstContainerLanguage.value,
                          onLangSelect: (selected) {
                            setState(() {
                              String selectedLanguage = selected!;
                              if (MytranslationController.controller.text.isNotEmpty &&
                                  MytranslationController.translatedText.value.isNotEmpty) {
                                addToHistory(MytranslationController.controller.text,
                                    MytranslationController.translatedText.value);
                              }

                              MytranslationController.firstContainerLanguage.value = selectedLanguage;
                              MytranslationController.controller.clear();
                              // MytranslationController.translatedText.value = '';
                            });
                          },
                          isFirstContainer: true,
                        );
                      },
                      child: LanguageContainer(
                        containerColor: Color(0XFF4169E1).withOpacity(0.76),
                        language: MytranslationController.firstContainerLanguage.value,
                        countryCode: MytranslationController.languageFlags[MytranslationController.firstContainerLanguage.value]!,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        swapLanguages(); // Call the swapLanguages method
                        setState(() {}); // Use setState to rebuild UI if necessary

                        void _onTextChanged() {
                          if (_debounceTimer?.isActive ?? false) {
                            _debounceTimer!.cancel();
                          }
                          _debounceTimer = Timer(const Duration(seconds:3), () {
                            _translateAndSpeak();
                          });
                        }
                        _debounceTimer?.cancel();
                        MytranslationController.controller.removeListener(_onTextChanged);
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0XFF4169E1).withOpacity(0.76), width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Color(0XFF4169E1).withOpacity(0.76), BlendMode.srcIn),
                          child: Image.asset(AppIcons.convertIcon, scale: 26),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        swapTap == false;
                        _showLanguageSelect(
                          currentLang: MytranslationController.secondContainerLanguage.value,
                          onLangSelect: (selected) {
                            setState(() {
                              MytranslationController.secondContainerLanguage.value = selected!;
                            });
                          },
                          isFirstContainer: false,
                        );
                      },
                      child: LanguageContainer(
                        containerColor: Color(0XFF4169E1).withOpacity(0.76),
                        language: MytranslationController.secondContainerLanguage.value,
                        countryCode: MytranslationController.languageFlags[MytranslationController.secondContainerLanguage.value]!,
                      ),
                    ),
                  ],
                ),
              ),

              _buildInputContainer(screenWidth, screenHeight),

              if(translationHistory.isNotEmpty)
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      final item = translationHistory[0];
                      final fromLanguage = item['fromLanguage'] ?? '';
                      final toLanguage = item['toLanguage'] ?? '';
                      final originalText = item['original'] ?? '';
                      final translatedText = item['translated'] ?? '';

                      final isOriginalRTL = MytranslationController.isRTLLanguage(fromLanguage);
                      final isTranslatedRTL = MytranslationController.isRTLLanguage(toLanguage);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: hasTranslation
                            ? Column(
                          children: [
                            // Source language section
                            _buildLanguageSection(
                              language: swapTap ? fromLanguage : toLanguage,
                              text: swapTap ? originalText : translatedText, // Use the original or translated text
                              isRTL: swapTap ? isOriginalRTL : isTranslatedRTL,
                              isTranslated: false,
                              myTranslationController: MytranslationController,
                            ),
                            // Target language section
                            _buildLanguageSection(
                              language: swapTap ? toLanguage : fromLanguage,
                              text: swapTap ? translatedText : originalText, // Use the original or translated text
                              isRTL: swapTap ? isTranslatedRTL : isOriginalRTL,
                              isTranslated: true,
                              myTranslationController: MytranslationController,
                              onSpeak: () {
                                if (swapTap == true) {
                                  String languageCode = MytranslationController.languageCodes[toLanguage] ?? 'ko';
                                  if (translatedText.contains('hello how are you') && languageCode == 'ko') {
                                    ttsService.speakText('你好，你好吗', 'ko', sliderController.speechSlider, sliderController.pitchSlider);
                                  } else {
                                    ttsService.speakText(translatedText, languageCode, sliderController.speechSlider, sliderController.pitchSlider);
                                  }
                                } else {
                                  String languageCode = MytranslationController.languageCodes[fromLanguage] ?? 'en-US';
                                  if (originalText.contains('hello how are you') && languageCode == 'ko') {
                                    ttsService.speakText('你好，你好吗', 'ko', sliderController.speechSlider, sliderController.pitchSlider);
                                  } else {
                                    ttsService.speakText(originalText, languageCode, sliderController.speechSlider, sliderController.pitchSlider);
                                  }
                                }
                              },
                              onDelete: () {
                                setState(() {
                                  hasTranslation = false;
                                  MytranslationController.controller.clear();
                                  ttsService.stop();
                                });
                              },
                            ),
                          ],
                        )
                            : Column(
                          children: [
                            SizedBox(height: 51),
                            Text('No text to translate. Please add new text.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              if(translationHistory.isEmpty)
                SizedBox(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer(double screenWidth, double screenHeight) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: screenWidth * 2.7,
        height: screenHeight * 0.33,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF).withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.asHeightBox,
            GestureDetector(
              child: SelectedLangShow(
                LangColor: Colors.black,
                containerColor: Colors.transparent,
                language: MytranslationController.firstContainerLanguage.value,
                countryCode: MytranslationController.languageFlags[
                MytranslationController.firstContainerLanguage.value]!,
              ),
            ),

            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Obx(() {
                    final isSourceRTL = MytranslationController.isRTLLanguage(
                        MytranslationController.firstContainerLanguage.value);
                    return TextFormField(

                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },

                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      controller: MytranslationController.controller,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: languageProvider.translate('type text here'),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      textAlign: isSourceRTL ? TextAlign.right : TextAlign.left,
                      textDirection: isSourceRTL ? TextDirection.rtl : TextDirection.ltr,
                    );
                  }),
                ),
              ),
            ),



            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomMic(
                    onTap: () async {
                      // ttsService.init();
                      // _ttsService.init();
                      // ttsService.dispose();
                      // _ttsService.dispose();
                      swapTap == false;
                      final selectedLanguageCode = '${MytranslationController.languageCodes[MytranslationController.firstContainerLanguage.value]}-US';
                      await handleSpeechToText(selectedLanguageCode);
                    },
                  ),
                  10.asWidthBox,
                  CustomTextBtn(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.52,
                      transController: MytranslationController.controller,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: Color(0XFF4169E1).withOpacity(0.76),
                      ),
                      textTitle: swapTap ? languageProvider.translate('Translate') : 'swap' ,
                      // textTitle: languageProvider.translate('Translate') ,

                      onTap: () async {
                        if (swapTap) {
                          ttsService.init();
                          _ttsService.init();
                          // Translate button logic
                          FocusScope.of(context).unfocus();
                          hasTranslation = true;

                          String originalText = MytranslationController.controller.text;

                          if (originalText.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Enter text to translate',
                              gravity: ToastGravity.CENTER,
                              webShowClose: true,
                            );
                            return;
                          }

                          if (_isLoadingTranslate) return;
                          _isLoadingTranslate = true;

                          try {
                            await ttsService.stop();
                            String? translatedText = await MytranslationController.translate(originalText);
                            if (translatedText != null && translatedText.isNotEmpty) {
                              MytranslationController.translatedText.value = translatedText;
                              addToHistory(originalText, translatedText);
                              setState(() {
                                _isTranslate = false;
                              });
                            } else {
                              Get.snackbar('Error', 'Translation failed. Please try again.');
                            }
                          } catch (e) {
                            Get.snackbar('Error', 'Translation failed: $e');
                          } finally {
                            _isLoadingTranslate = false;
                          }
                        } else {
                          /// ⬇️ When swap button is tapped
                          await swapLanguages(); // do the language and text swap

                          /// ⬇️ THEN immediately translate the swapped input to new target
                          String newInput = MytranslationController.controller.text;
                          if (newInput.isNotEmpty) {
                            try {
                              String? translatedText = await MytranslationController.translate(newInput);
                              if (translatedText != null && translatedText.isNotEmpty) {
                                MytranslationController.translatedText.value = translatedText;
                                addToHistory(newInput, translatedText);
                              } else {
                                Get.snackbar('Error', 'Re-translation failed after swap.');
                              }
                            } catch (e) {
                              Get.snackbar('Error', 'Error while translating after swap: $e');
                            }
                          }

                          /// Update mode
                          setState(() {
                            _isTranslate = true;
                            swapTap = true;
                          });
                        }
                      }
                  ),
                  10.asWidthBox,
                  THistoryBtn(
                    translationHistory: translationHistory,
                    onDelete: (index) {
                      setState(() {
                        translationHistory.removeAt(index);
                        // saveHistoryToSharedPreferences();
                      });
                    },
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection({
    required String language,
    required String text,
    required bool isRTL,
    required bool isTranslated,
    required MyTranslationController myTranslationController,
    void Function()? onSpeak,
    void Function()? onDelete,
  }) {
    final backgroundColor = isTranslated
        ? const Color(0xFF4169E1).withOpacity(0.76)
        : Colors.white;
    final textColor = isTranslated ? Colors.white : Colors.black;

    return Container(
      height: isTranslated ? 160 : 140,
      // padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: isTranslated
            ? null
            : Border(top: BorderSide(color: Colors.blueGrey.shade100, width: 2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                CountryFlag.fromCountryCode(
                  myTranslationController.languageFlags[language] ?? '',
                  height: 26,
                  width: 26,
                  shape: Circle(),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 170,
                  child: Text(
                    language,
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                // padding: EdgeInsets.zero,
                physics: AlwaysScrollableScrollPhysics(),
                child: SelectableText(
                  text,
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ),
            ),

            if (isTranslated)
              Row(
                mainAxisAlignment: isRTL ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: onSpeak,
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      ttsService.stop();
                      Clipboard.setData(ClipboardData(text: text));
                    },
                    child: Image.asset(
                      AppIcons.copyIcon,
                      scale: 26,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }


  Future<void> swapLanguages() async {
    String originalText = MytranslationController.controller.text;
    String translatedText = MytranslationController.translatedText.value;

    String tempLang = MytranslationController.firstContainerLanguage.value;
    MytranslationController.firstContainerLanguage.value = MytranslationController.secondContainerLanguage.value;
    MytranslationController.secondContainerLanguage.value = tempLang;

    if (_isTranslate) {
      MytranslationController.controller.text = translatedText;
      MytranslationController.translatedText.value = originalText;
    } else {
      MytranslationController.controller.text = translatedText;
      MytranslationController.translatedText.value = originalText;
    }
  }
}
