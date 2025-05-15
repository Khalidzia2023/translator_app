import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mnh/ads_screen/ad_helper/ad_helper.dart';
import 'package:mnh/views/languages/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../ads_manager/banner_cnrtl.dart';
import '../../ads_manager/interstitial_contrl.dart';
import '../../ads_manager/native_as.dart';
import '../../ads_manager/openApp_controller.dart';
import '../../catagory_screen.dart';
import '../../controller/category_contrl.dart';
import '../../translator/controller/translate_contrl.dart';
import '../../utils/app_images.dart';
import '../../view/see_diff/controller_sel.dart';
import '../../view/see_diff/model_sel.dart';
import '../../widgets/back_button.dart';
import '../../widgets/extensions/empty_space.dart';
import '../../widgets/text_widget.dart';
import '../../utils/app_icons.dart';


class PhrasesScreen extends StatefulWidget {
  const PhrasesScreen({super.key});

  @override
  State<PhrasesScreen> createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends State<PhrasesScreen> {

  // final bannerAdController = Get.find<BannerAdController>();
  final bannerAdController = Get.put(BannerAdController());
  final interstitialAdController = Get.put(InterstitialAdController());
  // final NativeAdController2 nativeAdController2 = Get.put(NativeAdController2());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // For drawer detection
  bool _showAd = true;
  bool _isLoading = false;


  // Swap languages method
  void swapLanguages() {
    String temp = firstContainerLanguage;
    firstContainerLanguage = secondContainerLanguage;
    secondContainerLanguage = temp;
    print('tapped on swap icon');
    controller.fetchPhrases();  // Fetch phrases after language swap
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

    firstContainerLanguage = "English";
    secondContainerLanguage = "Urdu";
    setState(() {
      _isLoading = true; // Set loading state
    });
    controller.fetchPhrases().then((_) {
      setState(() {
        _isLoading = false; // Set loading to false once data is fetched
      });
    });
    controller.fetchData(); // Ensure this fetches the necessary data
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  bool _isCooldown = false;
  bool _isTextAvailable = false;
  void hideAd() {
    setState(() {
      _showAd = false; // Hide the ad when sharing
    });
    print("=========> hideAd called, _showAd set to false");
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

  final MyTranslationController translationController = Get.put(MyTranslationController());
  final categoryController controller = Get.put(categoryController());
  final BTMController btmController = Get.put(BTMController());

  String firstContainerLanguage = "English";
  String secondContainerLanguage = "Urdu";

  TextEditingController _controller = TextEditingController();
  TextEditingController _shareController = TextEditingController();

  final List<String> leadingIcons = [
    AppImages.greetingsIcon,
    AppImages.conversationIcon,
    AppImages.numbersIcon,
    AppImages.dateTimeIcon,
    AppImages.directionIcon,
    AppImages.transportIcon,
    AppImages.accomodationIcon,
    AppImages.eatingIcon,
    AppImages.shoppingIcon,
    AppImages.colorsIcon,
    AppImages.townIcon,
    AppImages.countryIcon,
    AppImages.touristIcon,
    AppImages.familyIcon,
    AppImages.datingIcon,
    AppImages.emergencyIcon,
    AppImages.sickIcon,
    AppImages.twistorsIcon,
    AppImages.occasionsIcon,
    AppImages.bodyPartsIcon,
  ];

  String _getTranslation(BtmModel model, String language) {
    switch (language) {
    case "English":
        return model.english.isNotEmpty ? model.english : "No Translation";
    case "Afrikaans":
        return model.afrikaans.isNotEmpty ? model.afrikaans : "No Translation";
    case "Albanian":
        return model.albanian.isNotEmpty ? model.albanian : "No Translation";
    case "Amharic":
        return model.amharic.isNotEmpty ? model.amharic : "No Translation";
    case "Arabic":
        return model.arabic.isNotEmpty ? model.arabic : "No Translation";
    case "Armenian":
        return model.armenian.isNotEmpty ? model.armenian : "No Translation";
    case "Azeerbaijani":
        return model.azeerbaijani.isNotEmpty ? model.azeerbaijani : "No Translation";
    case "Basque":
        return model.basque.isNotEmpty ? model.basque : "No Translation";
    case "Belarusian":
        return model.belarusian.isNotEmpty ? model.belarusian : "No Translation";
    case "Bengali":
        return model.bengali.isNotEmpty ? model.bengali : "No Translation";
    case "Bosnian":
        return model.bosnian.isNotEmpty ? model.bosnian : "No Translation";
    case "Bulgarian":
        return model.bulgarian.isNotEmpty ? model.bulgarian : "No Translation";
    case "Catalan":
        return model.catalan.isNotEmpty ? model.catalan : "No Translation";
    case "Cebuano":
        return model.cebuano.isNotEmpty ? model.cebuano : "No Translation";
    case "ChineseSimplified":
        return model.chineseSimplified.isNotEmpty ? model.chineseSimplified : "No Translation";
    case "ChineseTraditional":
    return model.chineseTraditional.isNotEmpty ? model.chineseTraditional : "No Translation";
    case "Croatian":
    return model.croatian.isNotEmpty ? model.croatian : "No Translation";
    case "Czech":
    return model.czech.isNotEmpty ? model.czech : "No Translation";
    case "Danish":
    return model.danish.isNotEmpty ? model.danish : "No Translation";
    case "Dutch":
    return model.dutch.isNotEmpty ? model.dutch : "No Translation";
    case "Esperanto":
    return model.esperanto.isNotEmpty ? model.esperanto : "No Translation";
    case "Estonian":
    return model.estonian.isNotEmpty ? model.estonian : "No Translation";
    case "Finnish":
    return model.finnish.isNotEmpty ? model.finnish : "No Translation";
    case "French":
    return model.french.isNotEmpty ? model.french : "No Translation";
    case "Frisian":
    return model.frisian.isNotEmpty ? model.frisian : "No Translation";
    case "Galician":
    return model.galician.isNotEmpty ? model.galician : "No Translation";
    case "Georgian":
    return model.georgian.isNotEmpty ? model.georgian : "No Translation";
    case "German":
    return model.german.isNotEmpty ? model.german : "No Translation";
    case "Greek":
    return model.greek.isNotEmpty ? model.greek : "No Translation";
    case "Gujarati":
    return model.gujarati.isNotEmpty ? model.gujarati : "No Translation";
    case "Haitian":
    return model.haitian.isNotEmpty ? model.haitian : "No Translation";
    case "Hausa":
    return model.hausa.isNotEmpty ? model.hausa : "No Translation";
    case "Hawaiian":
    return model.hawaiian.isNotEmpty ? model.hawaiian : "No Translation";
    case "Hebrew":
    return model.hebrew.isNotEmpty ? model.hebrew : "No Translation";
    case "Hindi":
    return model.hindi.isNotEmpty ? model.hindi : "No Translation";
    case "Hmong":
    return model.hmong.isNotEmpty ? model.hmong : "No Translation";
    case "Hungarian":
    return model.hungarian.isNotEmpty ? model.hungarian : "No Translation";
    case "Icelandic":
    return model.icelandic.isNotEmpty ? model.icelandic : "No Translation";
    case "Indonesian":
    return model.indonesian.isNotEmpty ? model.indonesian : "No Translation";
    case "Irish":
    return model.irish.isNotEmpty ? model.irish : "No Translation";
    case "Italian":
    return model.italian.isNotEmpty ? model.italian : "No Translation";
    case "Japanese":
    return model.japanese.isNotEmpty ? model.japanese : "No Translation";
    case "Javanese":
    return model.javanese.isNotEmpty ? model.javanese : "No Translation";
    case "Kannada":
    return model.kannada.isNotEmpty ? model.kannada : "No Translation";
    case "Kazakh":
    return model.kazakh.isNotEmpty ? model.kazakh : "No Translation";
    case "Khmer":
    return model.khmer.isNotEmpty ? model.khmer : "No Translation";
    case "KoreanNK":
    return model.koreanNK.isNotEmpty ? model.koreanNK : "No Translation";
    case "KoreanSK":
    return model.koreanSK.isNotEmpty ? model.koreanSK : "No Translation";
    case "Kurdish":
    return model.kurdish.isNotEmpty ? model.kurdish : "No Translation";
    case "Kyrgyz":
    return model.kyrgyz.isNotEmpty ? model.kyrgyz : "No Translation";
    case "Lao":
    return model.lao.isNotEmpty ? model.lao : "No Translation";
    case "Latin":
    return model.latin.isNotEmpty ? model.latin : "No Translation";
    case "Latvian":
    return model.latvian.isNotEmpty ? model.latvian : "No Translation";
    case "Lithuanian":
    return model.lithuanian.isNotEmpty ? model.lithuanian : "No Translation";
    case "Luxembourgish":
    return model.luxembourgish.isNotEmpty ? model.luxembourgish : "No Translation";
    case "Macedonian":
    return model.macedonian.isNotEmpty ? model.macedonian : "No Translation";
    case "Malagasy":
    return model.malagasy.isNotEmpty ? model.malagasy : "No Translation";
    case "Malay":
    return model.malay.isNotEmpty ? model.malay : "No Translation";
    case "Malayalam":
    return model.malayalam.isNotEmpty ? model.malayalam : "No Translation";
    case "Maltese":
    return model.maltese.isNotEmpty ? model.maltese : "No Translation";
    case "Maori":
    return model.maori.isNotEmpty ? model.maori : "No Translation";
    case "Marathi":
    return model.marathi.isNotEmpty ? model.marathi : "No Translation";
    case "Mongolian":
    return model.mongolian.isNotEmpty ? model.mongolian : "No Translation";
    case "MyanmarBurmese":
    return model.myanmarBurmese.isNotEmpty ? model.myanmarBurmese : "No Translation";
    case "Nepali":
    return model.nepali.isNotEmpty ? model.nepali : "No Translation";
    case "Norwegian":
    return model.norwegian.isNotEmpty ? model.norwegian : "No Translation";
    case "NyanjaChichewa":
    return model.nyanjaChichewa.isNotEmpty ? model.nyanjaChichewa : "No Translation";
    case "Pashto":
    return model.pashto.isNotEmpty ? model.pashto : "No Translation";
    case "Persian":
    return model.persian.isNotEmpty ? model.persian : "No Translation";
    case "Polish":
    return model.polish.isNotEmpty ? model.polish : "No Translation";
    case "Portuguese":
    return model.portuguese.isNotEmpty ? model.portuguese : "No Translation";
    case "Punjabi":
    return model.punjabi.isNotEmpty ? model.punjabi : "No Translation";
    case "Romanian":
    return model.romanian.isNotEmpty ? model.romanian : "No Translation";
    case "Russian":
    return model.russian.isNotEmpty ? model.russian : "No Translation";
    case "Samoan":
    return model.samoan.isNotEmpty ? model.samoan : "No Translation";
    case "ScotsGaelic":
    return model.scotsGaelic.isNotEmpty ? model.scotsGaelic : "No Translation";
    case "Serbian":
    return model.serbian.isNotEmpty ? model.serbian : "No Translation";
    case "Sesotho":
    return model.sesotho.isNotEmpty ? model.sesotho : "No Translation";
    case "Shona":
    return model.shona.isNotEmpty ? model.shona : "No Translation";
    case "Sindhi":
    return model.sindhi.isNotEmpty ? model.sindhi : "No Translation";
    case "Sinhala":
    return model.sinhala.isNotEmpty ? model.sinhala : "No Translation";
    case "Slovak":
    return model.slovak.isNotEmpty ? model.slovak : "No Translation";
    case "Slovenian":
    return model.slovenian.isNotEmpty ? model.slovenian : "No Translation";
    case "Somali":
    return model.somali.isNotEmpty ? model.somali : "No Translation";
    case "Spanish":
    return model.spanish.isNotEmpty ? model.spanish : "No Translation";
    case "Sundanese":
    return model.sundanese.isNotEmpty ? model.sundanese : "No Translation";
    case "Swahili":
    return model.swahili.isNotEmpty ? model.swahili : "No Translation";
    case "Swedish":
    return model.swedish.isNotEmpty ? model.swedish : "No Translation";
    case "Tagalog":
    return model.tagalog.isNotEmpty ? model.tagalog : "No Translation";
    case "Tajik":
    return model.tajik.isNotEmpty ? model.tajik : "No Translation";
    case "Tamil":
    return model.tamil.isNotEmpty ? model.tamil : "No Translation";
    case "Telugu":
    return model.telugu.isNotEmpty ? model.telugu : "No Translation";
    case "Thai":
    return model.thai.isNotEmpty ? model.thai : "No Translation";
    case "Turkish":
    return model.turkish.isNotEmpty ? model.turkish : "No Translation";
    case "Ukrainian":
    return model.ukrainian.isNotEmpty ? model.ukrainian : "No Translation";
    case "Urdu":
    return model.urdu.isNotEmpty ? model.urdu : "No Translation";
    case "Uzbek":
    return model.uzbek.isNotEmpty ? model.uzbek : "No Translation";
    case "Vietnamese":
    return model.vietnamese.isNotEmpty ? model.vietnamese : "No Translation";
    case "Welsh":
    return model.welsh.isNotEmpty ? model.welsh : "No Translation";
    case "Xhosa":
    return model.xhosa.isNotEmpty ? model.xhosa : "No Translation";
    case "Yiddish":
    return model.yiddish.isNotEmpty ? model.yiddish : "No Translation";
    case "Yoruba":
    return model.yoruba.isNotEmpty ? model.yoruba : "No Translation";
    case "Zulu":
    return model.zulu.isNotEmpty ? model.zulu : "No Translation";
    default:
    return model.english.isNotEmpty ? model.english : "No Translation";


    }
  }

  void _showLanguageSelector({
    required String currentLanguage,
    required void Function(String) onLanguageSelected,
  }) {
    TextEditingController searchController = TextEditingController();
    ValueNotifier<String> searchQuery = ValueNotifier<String>('');
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final languageProvider = Provider.of<LanguageProvider>(context);
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 1.3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    SizedBox(height: 16,),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: languageProvider.translate('Search language...'),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery.value = value.toLowerCase();
                        });
                      },
                    ),
                    Flexible(
                      child: ValueListenableBuilder<String>(
                        valueListenable: searchQuery,
                        builder: (context, query, child) {
                          var filteredLanguages = languageCountryCode.keys
                              .where((language) => language.toLowerCase().contains(query))
                              .toList();

                          return ListView.builder(
                            itemCount: filteredLanguages.length,
                            itemBuilder: (context, index) {
                              String language = filteredLanguages[index];
                              String code = languageCountryCode[language]!['code']!;
                              return Padding(
                                padding: const EdgeInsets.symmetric( vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: ListTile(
                                    tileColor: Colors.grey.shade200,
                                    title: Text(language, style: TextStyle(fontSize: 16)),
                                    dense: true,
                                    leading: CountryFlag.fromCountryCode(
                                      code,
                                      height: 25,
                                      shape: Circle(),
                                    ),
                                    trailing: currentLanguage == language
                                        ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                                        : null,
                                    onTap: () {
                                      onLanguageSelected(language);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  final OpenAppAdController openAppAdController = Get.put(OpenAppAdController());
  bool _isAdVisible = true;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth  = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // Check if interstitial ad is showing
    final isInterstitialShowing = interstitialAdController.showInterstitialAd;


    final showAdWidget = _showAd && bannerAdController.isAdReady('large2') && !isKeyboardOpen && !isInterstitialShowing;

    // Print detailed logs for debugging
    print("=========> isKeyboardOpen: $isKeyboardOpen");
    print("=========> isInterstitialShowing: $isInterstitialShowing");
    print("=========> _showAd: $_showAd");
    print("=========> nativeAdController2.isAdReady: ${bannerAdController.isAdReady}");
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
      backgroundColor: Color(0XFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
        leading: CustomBackButton(
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios,
          iconSize: 24,
          btnColor: Colors.white,
        ),
        title: regularText(
          title:    languageProvider.translate('Phrases Categories'),
          textSize: screenWidth * 0.056,
          textColor: Colors.white,
          textWeight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: openAppAdController.adAlreadyShown || isKeyboardOpen
          ? SizedBox()
          : _isAdVisible && bannerAdController.isAdReady('ad2')
          ? bannerAdController.getBannerAdWidget('ad2')
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
      ),// Display the ad
      body: Stack(
        children: [
          Column(
            children: [
              10.asHeightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showLanguageSelector(
                        currentLanguage: firstContainerLanguage,
                        onLanguageSelected: (selected) {
                          setState(() {
                            firstContainerLanguage= selected;
                          });
                          controller.fetchPhrases();  // Fetch data after language change
                        },
                      );
                    },
                    child: LanguageContainer(
                      language:firstContainerLanguage,
                      countryCode: languageCountryCode[firstContainerLanguage]!['code']!,
                    ),
                  ),
                  Container(
                    height: 30, width: 30,
                    decoration: BoxDecoration(

                        border: Border.all(color: Color(0XFF4169E1).withValues(alpha: .76),width: 2),
                        // color: Colors.blueGrey.shade100,
                        shape: BoxShape.circle
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode( Color(0XFF4169E1).withValues(alpha: .76),
                          BlendMode.srcIn),
                      child: GestureDetector(
                          onTap: () {
                            // interstitialAdController.checkAndShowAdOnVisit();
                            print('tapped');
                            setState(() {
                              swapLanguages();
                            });
                          },
                          child: Image.asset(AppIcons.convertIcon, scale: 26,)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                    _showLanguageSelector(
                    currentLanguage: secondContainerLanguage,
                    onLanguageSelected: (selected) {
                      setState(() {
                        secondContainerLanguage = selected;
                      });
                      controller.fetchPhrases();  // Fetch data after language change
                    },
                  ),
                    },
                    child: LanguageContainer(
                      language: secondContainerLanguage,
                      countryCode: languageCountryCode[secondContainerLanguage]!['code']!,
                    ),
                  ),
                ],
              ),
              20.asHeightBox,
              _isLoading
                  ? Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : Expanded(
                child: Obx(() {
                  final isSourceRTL = translationController.isRTLLanguage(
                      translationController.firstContainerLanguage.value);
                  if (btmController.categor.isEmpty) {

                    return Center(child: Text('No data available.'));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: btmController.categor.length,
                    itemBuilder: (context, index) {
                      final model = btmController.categor[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: Offset(0.2, 1.8),
                                blurRadius: 0.2,
                                // spreadRadius: .2,
                              )
                            ]
                            // border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: InkWell(
                            onTap: () {
                              // interstitialAdController.checkAndShowAdOnVisit();

                              // Triggering the tap effect delay before navigating
                              Future.delayed(Duration(milliseconds: 500), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PhrasesCategoryScreen(
                                      id: index + 1,
                                      name: _getTranslation(model, ''),
                                      titleLang: firstContainerLanguage,
                                      subtitleLang: secondContainerLanguage,
                                      copyController: _controller,
                                      shareController: _shareController,
                                      volumeController: _controller,
                                    ),
                                  ),
                                );
                              });
                            },
                            child: ListTile(
                              // contentPadding: EdgeInsets.zero,
                              title: Text(
                                _getTranslation(model, firstContainerLanguage), // Get the translated text

                                style: TextStyle(fontSize: 18, ),
                              ),
                              subtitle: Text(
                                _getTranslation(model, secondContainerLanguage), // Get the translated text

                                style: TextStyle(color: Color(0XFF4169E1).withValues(alpha: .9), fontSize: 16),
                              ),
                              leading: Image.asset(leadingIcons[index], scale: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class LanguageContainer extends StatelessWidget {
  final String language;
  final String countryCode;

  const LanguageContainer({
    required this.language,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // Truncate language if its length exceeds 10 characters
    String displayLanguage = language.length > 7 ? '${language.substring(0, 7)}...' : language;

    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0XFF4169E1).withOpacity(0.76),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 3,
        children: [
          SizedBox(width: 4),
          CountryFlag.fromCountryCode(
            countryCode,
            height: 26,
            width: 26,
            shape: Circle(),
          ),
          Text(
            displayLanguage,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.046,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

