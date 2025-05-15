import 'dart:io';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mnh/ads_screen/ad_helper/ad_helper.dart';
import 'package:mnh/controller/category_contrl.dart';
import 'package:mnh/models/phrase_model.dart';
import 'package:mnh/translator/controller/translate_contrl.dart';
import 'package:mnh/tts_service.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/languages/provider/language_provider.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity, ConnectivityResult;
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'ads_manager/banner_cnrtl.dart';
import 'ads_manager/interstitial_contrl.dart';
import 'ads_manager/openApp_controller.dart';

class PhrasesCategoryScreen extends StatefulWidget {

  final int id;
  final String name;
  final String titleLang;
  final String subtitleLang;
  final TextEditingController copyController;
  final TextEditingController shareController;
  final TextEditingController volumeController;

  const PhrasesCategoryScreen({
    super.key,
    required this.id,
    required this.name,
    required this.titleLang,
    required this.subtitleLang,
    required this.copyController,
    required this.shareController,
    required this.volumeController,
  });

  @override
  State<PhrasesCategoryScreen> createState() => _PhrasesCategoryScreenState();
}

class _PhrasesCategoryScreenState extends State<PhrasesCategoryScreen> {
  final MyTranslationController translationController = Get.put(MyTranslationController());
  final MyTranslationController MytranslationController = Get.put(MyTranslationController());


  double _pitchSlider = 1.0;
  double _speechSlider = 1.0;

  final interstitialAdController = Get.find<InterstitialAdController>();
  final BannerAdController bannerAdController = Get.find<BannerAdController>();


  final List<String> langList = ["Arabic", "Urdu", "Hebrew", "Persian"];
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedValue = 'English'; // Default language
  final TtsService ttsService = TtsService();



  String firstContainerLanguage = "English";
  String secondContainerLanguage = "Urdu";

  void speakTranslatedText(String text, String subtitleLang) {
    String languageCode = MytranslationController.languageCodes[subtitleLang]!;

    // Check if text is empty
    if (text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No text to speak',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Stop any ongoing speech before starting new speech
    _flutterTts.stop().then((_) {
      // Now speak the new text after stopping the ongoing speech
      ttsService.speakText(text, languageCode,_speechSlider, _pitchSlider);
    });
  }
  final Map<String, Map<String, String>> languageCountryCode = {
    "English": {"code": "US", "country": "United States"},
    "Afrikaans": {"code": "ZA", "country": "South Africa"},
    "Albanian": {"code": "AL", "country": "Albania"},
    "Amharic": {"code": "ET", "country": "Ethiopia"},
    "Arabic": {"code": "SA", "country": "Saudi Arabia"},
    "Armenian": {"code": "AM", "country": "Armenia"},
    "Azerbaijani": {"code": "AZ", "country": "Azerbaijan"},
    "Basque": {"code": "ES", "country": "Spain"},
    "Belarusian": {"code": "BY", "country": "Belarus"},
    "Bengali": {"code": "BD", "country": "Bangladesh"},
    "Bosnian": {"code": "BA", "country": "Bosnia and Herzegovina"},
    "Bulgarian": {"code": "BG", "country": "Bulgaria"},
    "Catalan": {"code": "ES", "country": "Spain"},
    "Cebuano": {"code": "PH", "country": "Philippines"},
    "ChineseSimplified": {"code": "CN", "country": "China"},
    "ChineseTraditional": {"code": "TW", "country": "Taiwan"},
    "Croatian": {"code": "HR", "country": "Croatia"},
    "Czech": {"code": "CZ", "country": "Czech Republic"},
    "Danish": {"code": "DK", "country": "Denmark"},
    "Dutch": {"code": "NL", "country": "Netherlands"},
    "Esperanto": {"code": "ZZ", "country": "Esperanto"},
    "Estonian": {"code": "EE", "country": "Estonia"},
    "Finnish": {"code": "FI", "country": "Finland"},
    "French": {"code": "FR", "country": "France"},
    "Frisian": {"code": "NL", "country": "Netherlands"},
    "Galician": {"code": "ES", "country": "Spain"},
    "Georgian": {"code": "GE", "country": "Georgia"},
    "German": {"code": "DE", "country": "Germany"},
    "Greek": {"code": "GR", "country": "Greece"},
    "Gujarati": {"code": "IN", "country": "India"},
    "Haitian": {"code": "HT", "country": "Haiti"},
    "Hausa": {"code": "NG", "country": "Nigeria"},
    "Hawaiian": {"code": "US", "country": "United States"},
    "Hebrew": {"code": "IL", "country": "Israel"},
    "Hindi": {"code": "IN", "country": "India"},
    "Hmong": {"code": "LA", "country": "Laos"},
    "Hungarian": {"code": "HU", "country": "Hungary"},
    "Icelandic": {"code": "IS", "country": "Iceland"},
    "Indonesian": {"code": "ID", "country": "Indonesia"},
    "Irish": {"code": "IE", "country": "Ireland"},
    "Italian": {"code": "IT", "country": "Italy"},
    "Japanese": {"code": "JP", "country": "Japan"},
    "Javanese": {"code": "ID", "country": "Indonesia"},
    "Kannada": {"code": "IN", "country": "India"},
    "Kazakh": {"code": "KZ", "country": "Kazakhstan"},
    "Khmer": {"code": "KH", "country": "Cambodia"},
    "KoreanNK": {"code": "KP", "country": "North Korea"},
    "KoreanSK": {"code": "KR", "country": "South Korea"},
    "Kurdish": {"code": "IQ", "country": "Iraq"},
    "Kyrgyz": {"code": "KG", "country": "Kyrgyzstan"},
    "Lao": {"code": "LA", "country": "Laos"},
    "Latin": {"code": "ZZ", "country": "Latin"},
    "Latvian": {"code": "LV", "country": "Latvia"},
    "Lithuanian": {"code": "LT", "country": "Lithuania"},
    "Luxembourgish": {"code": "LU", "country": "Luxembourg"},
    "Macedonian": {"code": "MK", "country": "North Macedonia"},
    "Malagasy": {"code": "MG", "country": "Madagascar"},
    "Malay": {"code": "MY", "country": "Malaysia"},
    "Malayalam": {"code": "IN", "country": "India"},
    "Maltese": {"code": "MT", "country": "Malta"},
    "Maori": {"code": "NZ", "country": "New Zealand"},
    "Marathi": {"code": "IN", "country": "India"},
    "Mongolian": {"code": "MN", "country": "Mongolia"},
    "MyanmarBurmese": {"code": "MM", "country": "Myanmar"},
    "Nepali": {"code": "NP", "country": "Nepal"},
    "Norwegian": {"code": "NO", "country": "Norway"},
    "NyanjaChichewa": {"code": "MW", "country": "Malawi"},
    "Pashto": {"code": "AF", "country": "Afghanistan"},
    "Persian": {"code": "IR", "country": "Iran"},
    "Polish": {"code": "PL", "country": "Poland"},
    "Portuguese": {"code": "PT", "country": "Portugal"},
    "Punjabi": {"code": "IN", "country": "India"},
    "Romanian": {"code": "RO", "country": "Romania"},
    "Russian": {"code": "RU", "country": "Russia"},
    "Samoan": {"code": "WS", "country": "Samoa"},
    "ScotsGaelic": {"code": "GB", "country": "United Kingdom"},
    "Serbian": {"code": "RS", "country": "Serbia"},
    "Sesotho": {"code": "LS", "country": "Lesotho"},
    "Shona": {"code": "ZW", "country": "Zimbabwe"},
    "Sindhi": {"code": "PK", "country": "Pakistan"},
    "Sinhala": {"code": "LK", "country": "Sri Lanka"},
    "Slovak": {"code": "SK", "country": "Slovakia"},
    "Slovenian": {"code": "SI", "country": "Slovenia"},
    "Somali": {"code": "SO", "country": "Somalia"},
    "Spanish": {"code": "ES", "country": "Spain"},
    "Sundanese": {"code": "ID", "country": "Indonesia"},
    "Swahili": {"code": "KE", "country": "Kenya"},
    "Swedish": {"code": "SE", "country": "Sweden"},
    "Tagalog": {"code": "PH", "country": "Philippines"},
    "Tajik": {"code": "TJ", "country": "Tajikistan"},
    "Tamil": {"code": "IN", "country": "India"},
    "Telugu": {"code": "IN", "country": "India"},
    "Thai": {"code": "TH", "country": "Thailand"},
    "Turkish": {"code": "TR", "country": "Turkey"},
    "Ukrainian": {"code": "UA", "country": "Ukraine"},
    "Urdu": {"code": "PK", "country": "Pakistan"},
    "Uzbek": {"code": "UZ", "country": "Uzbekistan"},
    "Vietnamese": {"code": "VN", "country": "Vietnam"},
    "Welsh": {"code": "GB", "country": "United Kingdom"},
    "Xhosa": {"code": "ZA", "country": "South Africa"},
    "Yiddish": {"code": "ZZ", "country": "Yiddish"},
    "Yoruba": {"code": "NG", "country": "Nigeria"},
    "Zulu": {"code": "ZA", "country": "South Africa"},
  };


  List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOnline = false; //


  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
    ttsService.dispose();
    _connectivitySubscription.cancel();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    interstitialAdController.showAd();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();
    WidgetsBinding.instance.addPostFrameCallback((_) {

        bannerAdController.loadBannerAd('large1');

    });

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
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        _isOnline = true;
      } else {
        _isOnline = false;
      }
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
                  regularText( alignText: TextAlign.center,title: 'Please check your internet connection.', textSize: 16, textColor: Colors.black, textWeight: FontWeight.w200),
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
  final categoryController controller = Get.put(categoryController());

  String _getTranslation(PhrasesModel model, String titleLang) {
    switch (titleLang) {
      case "English":
        return model.english;
      case "Afrikaans":
        return model.afrikaans;
      case "Albanian":
        return model.albanian;
      case "Amharic":
        return model.amharic;
      case "Arabic":
        return model.arabic;
      case "Armenian":
        return model.armenian;
      case "Azerbaijani":
        return model.azeerbaijani;
      case "Basque":
        return model.basque;
      case "Belarusian":
        return model.belarusian;
      case "Bengali":
        return model.bengali;
      case "Bosnian":
        return model.bosnian;
      case "Bulgarian":
        return model.bulgarian;
      case "Catalan":
        return model.catalan;
      case "Cebuano":
        return model.cebuano;
      case "Chinese Simplified":
        return model.chineseSimplified;
      case "Chinese Traditional":
        return model.chineseTraditional;
      case "Croatian":
        return model.croatian;
      case "Czech":
        return model.czech;
      case "Danish":
        return model.danish;
      case "Dutch":
        return model.dutch;
      case "Esperanto":
        return model.esperanto;
      case "Estonian":
        return model.estonian;
      case "Finnish":
        return model.finnish;
      case "French":
        return model.french;
      case "Frisian":
        return model.frisian;
      case "Galician":
        return model.galician;
      case "Georgian":
        return model.georgian;
      case "German":
        return model.german;
      case "Greek":
        return model.greek;
      case "Gujarati":
        return model.gujarati;
      case "Haitian":
        return model.haitian;
      case "Hausa":
        return model.hausa;
      case "Hawaiian":
        return model.hawaiian;
      case "Hebrew":
        return model.hebrew;
      case "Hindi":
        return model.hindi;
      case "Hmong":
        return model.hmong;
      case "Hungarian":
        return model.hungarian;
      case "Icelandic":
        return model.icelandic;
      case "Indonesian":
        return model.indonesian;
      case "Irish":
        return model.irish;
      case "Italian":
        return model.italian;
      case "Japanese":
        return model.japanese;
      case "Javanese":
        return model.javanese;
      case "Kannada":
        return model.kannada;
      case "Kazakh":
        return model.kazakh;
      case "Khmer":
        return model.khmer;
      case "Korean NK":
        return model.koreanNK;
      case "Korean SK":
        return model.koreanSK;
      case "Kurdish":
        return model.kurdish;
      case "Kyrgyz":
        return model.kyrgyz;
      case "Lao":
        return model.lao;
      case "Latin":
        return model.latin;
      case "Latvian":
        return model.latvian;
      case "Lithuanian":
        return model.lithuanian;
      case "Luxembourgish":
        return model.luxembourgish;
      case "Macedonian":
        return model.macedonian;
      case "Malagasy":
        return model.malagasy;
      case "Malay":
        return model.malay;
      case "Malayalam":
        return model.malayalam;
      case "Maltese":
        return model.maltese;
      case "Maori":
        return model.maori;
      case "Marathi":
        return model.marathi;
      case "Mongolian":
        return model.mongolian;
      case "Myanmar Burmese":
        return model.myanmarBurmese;
      case "Nepali":
        return model.nepali;
      case "Norwegian":
        return model.norwegian;
      case "Nyanja Chichewa":
        return model.nyanjaChichewa;
      case "Pashto":
        return model.pashto;
      case "Persian":
        return model.persian;
      case "Polish":
        return model.polish;
      case "Portuguese":
        return model.portuguese;
      case "Punjabi":
        return model.punjabi;
      case "Romanian":
        return model.romanian;
      case "Russian":
        return model.russian;
      case "Samoan":
        return model.samoan;
      case "Scots Gaelic":
        return model.scotsGaelic;
      case "Serbian":
        return model.serbian;
      case "Sesotho":
        return model.sesotho;
      case "Shona":
        return model.shona;
      case "Sindhi":
        return model.sindhi;
      case "Sinhala":
        return model.sinhala;
      case "Slovak":
        return model.slovak;
      case "Slovenian":
        return model.slovenian;
      case "Somali":
        return model.somali;
      case "Spanish":
        return model.spanish;
      case "Sundanese":
        return model.sundanese;
      case "Swahili":
        return model.swahili;
      case "Swedish":
        return model.swedish;
      case "Tagalog":
        return model.tagalog;
      case "Tajik":
        return model.tajik;
      case "Tamil":
        return model.tamil;
      case "Telugu":
        return model.telugu;
      case "Thai":
        return model.thai;
      case "Turkish":
        return model.turkish;
      case "Ukrainian":
        return model.ukrainian;
      case "Urdu":
        return model.urdu;
      case "Uzbek":
        return model.uzbek;
      case "Vietnamese":
        return model.vietnamese;
      case "Welsh":
        return model.welsh;
      case "Xhosa":
        return model.xhosa;
      case "Yiddish":
        return model.yiddish;
      case "Yoruba":
        return model.yoruba;
      case "Zulu":
        return model.zulu;
      default:
        return model.english;
    }
  }

  // To track the active icons individually for each item (copy, share, volume)
  Map<int, String> activeIcons =
      {}; // Key is index, value is the icon type ("copy", "share", "volume")

  void _handleIconClick(int index, String text, String iconType) {
    setState(() {
      // Only update the tapped icon
      // Check internet connection
      if (!_isOnline) {
        _showNoConnectionDialog();
        return;
      }

      if (activeIcons[index] == iconType) {
        activeIcons.remove(index); // Remove if the same icon is tapped again
      } else {
        activeIcons[index] = iconType; // Set the clicked icon type
      }
    });

    // Handle specific actions for each icon
    if (iconType == "share" && text.isNotEmpty) {
      Share.share(text);
    } else if (iconType == "copy") {
      // Copy the text to clipboard
      final textToCopy = text;
      Clipboard.setData(ClipboardData(text: textToCopy)).then(
        (_) {
          Fluttertoast.showToast(msg: 'Text Copied to Clipboard');
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No text to share!')),
      );
    }

    // Revert the color back to default after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        activeIcons.remove(index); // Remove the index after timeout
      });
    });
  }
  final OpenAppAdController openAppAdController = Get.put(OpenAppAdController());
  bool _isAdVisible = true;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0XFFE0E0E0),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.chevron_left, color: Colors.white, size: 38),
        ),
        title: Text(
          " ${languageProvider.translate(widget.name)}",
          style: TextStyle(
            fontSize: screenWidth * 0.056,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
      ),
        bottomNavigationBar: openAppAdController.adAlreadyShown
            ? SizedBox()
            : _isAdVisible && bannerAdController.isAdReady('ad6')
            ? bannerAdController.getBannerAdWidget4('ad6')
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
      body: Obx(() {
        // Filter phrases by category ID
        final filterPhraseID = controller.phrases
            .where((phrase) => phrase.category_id == widget.id)
            .toList();

        return ListView.builder(
            itemCount: filterPhraseID.length,
            itemBuilder: (context, index) {
          final item = filterPhraseID[index];
          final isActiveCopy = activeIcons[index] == "copy";
          final isActiveShare = activeIcons[index] == "share";
          final isActiveVolume = activeIcons[index] == "volume";
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                Container(
                  height: screenHeight * 0.16,
                  width: screenWidth * 0.92,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          offset: Offset(0.2, 1.8),
                          blurRadius: 0.2,
                          // spreadRadius: .2,
                        )
                      ]
                  ),

                  child: Column(
                    crossAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.titleLang))
                        ? CrossAxisAlignment.end   : CrossAxisAlignment.start,
                    children: [
                      LanguageContainer(
                        language: widget.titleLang, // Use the selected language
                        countryCode: languageCountryCode[widget.titleLang]!['code']!, // Get the country code dynamically
                        textColor: Colors.black,
                      ),
                      Flexible(
                        child: Text(
                          _getTranslation(item, widget.titleLang), // Get translation based on the selected language
                          textDirection: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.titleLang))
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          softWrap: true,
                          maxLines: null,
                          locale: Locale(_selectedValue),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.052,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: screenHeight * 0.16,
                    width: screenWidth * 0.92,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0XFF4169E1).withValues(alpha: .76),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)

                        ),
                        boxShadow:[
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: Offset(0.2, 1.8),
                            blurRadius: 0.2,
                            // spreadRadius: .2,
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"]
                          .contains(widget.subtitleLang))
                          ? CrossAxisAlignment.end   : CrossAxisAlignment.start,
                      children: [
                        LanguageContainer(
                          language: widget.subtitleLang, // Use the selected language
                          countryCode: languageCountryCode[
                          widget.subtitleLang]!['code']!, // Get the country code dynamically
                          textColor: Colors.white,

                        ),

                        Flexible(
                          child: Text(
                            _getTranslation(item, widget.subtitleLang), // Get translation based on the selected language
                            textDirection: (["Arabic", "Urdu", "Hebrew", "Persian"]
                                .contains(widget.titleLang))
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            softWrap: true,
                            maxLines: null,
                            locale: Locale(_selectedValue),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.052,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.subtitleLang))
                              ? MainAxisAlignment.start // RTL languages → Buttons align LEFT
                              : MainAxisAlignment.end,
                          children: [
                            // Copy Icon
                            GestureDetector(
                              onTap: () {
                                final textToCopy = _getTranslation(
                                    item, widget.subtitleLang);
                                _handleIconClick(index, textToCopy, "copy");
                              },
                              child: Image.asset(
                                AppIcons.copyIcon,
                                scale: screenHeight * 0.027,
                                color: isActiveCopy
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            // Share Icon
                            GestureDetector(
                              onTap: () {
                                final text = _getTranslation(
                                    item, widget.subtitleLang);
                                _handleIconClick(index, text,"share");
                              },
                              child: Image.asset(
                                AppIcons.sharIcon,
                                scale: screenHeight * 0.027,
                                color: isActiveShare
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            // Volume Icon
                            GestureDetector(
                              onTap: () async {
                                // Check internet connection
                                if (!_isOnline) {
                                  _showNoConnectionDialog();
                                  return;
                                }

                                String textToSpeak = _getTranslation(item, widget.subtitleLang);
                                speakTranslatedText(textToSpeak, widget.subtitleLang);
                                setState(() {
                                  activeIcons[index] = "volume"; // Set active state
                                });
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  if (mounted) {
                                    setState(() {
                                      activeIcons[index] = ""; // Reset state after delay
                                    });
                                  }
                                });
                              },
                              child: Image.asset(
                                AppIcons.volumeIcon,
                                scale: screenHeight * 0.025,
                                color: activeIcons[index] == "volume" ? Colors.black : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                              ],
            ),
          );
        });

      }),
    );
  }
}


class LanguageContainer extends StatelessWidget {
  final String language;
  final String countryCode;
  final Color textColor;

  const LanguageContainer({
    required this.language,
    required this.countryCode,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Truncate language if its length exceeds 10 characters
    String displayLanguage = language.length > 8 ? '${language.substring(0, 8)}...' : language;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 6,
      children: [

        CountryFlag.fromCountryCode(
          countryCode,
          height: 20,
          width: 20,
          shape: Circle(),
        ),
        Text(
          displayLanguage,
          style: TextStyle(
            color: textColor,
            fontSize: screenWidth * 0.042,
          ),
        ),

      ],
    );
  }
}

