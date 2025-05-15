import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mnh/utils/app_images.dart';
import 'package:mnh/views/languages/provider/language_provider.dart';
import 'package:mnh/views/spell_pronounce/spell_pronounce.dart';
import 'package:mnh/views/splash_screen/splash_screen.dart';
import 'package:mnh/widgets/back_button.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:shared_preferences/shared_preferences.dart';
import '../../ads_manager/banner_cnrtl.dart';
import '../../ads_manager/interstitial_contrl.dart';
import '../../widgets/custom_tile.dart';
class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int? _selectedValue;

  // final interstitialAdController = Get.find<InterstitialAdController>();

  final List<String> languageNames = [
    'English',
    'Hindi',
    'Arabic',
    'Urdu',
    'Spanish',
    'Korean',
    'French',
    'Portuguese',
    'German'
  ];

  final List<String> countriesFlag = [
    AppImages.UKFlag,
    AppImages.hindiFlag,
    AppImages.saudiaFlag,
    AppImages.pakistanFlag,
    AppImages.spainFlag,
    AppImages.koreanFlag,
    AppImages.frenchFlag,
    AppImages.portugueseFlag,
    AppImages.germanFlag,
  ];

  @override
  void initState() {
    super.initState();
    // interstitialAdController.checkAndShowAdOnVisit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      _selectedValue = languageNames.indexWhere(
              (lang) => languageProvider.currentLanguage == _getLanguageCode(lang));
      setState(() {});
    });
  }

  void _onChanged(int? value) {
    setState(() {
      _selectedValue = value;
      String selectedLanguageCode = _getLanguageCode(languageNames[value!]);
      Provider.of<LanguageProvider>(context, listen: false).setLanguage(selectedLanguageCode);
    });
  }

  String _getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Hindi':
        return 'hi';
      case 'Arabic':
        return 'ar';
      case 'Urdu':
        return 'ur';
      case 'Spanish':
        return 'es';
      case 'Korean':
        return 'ko';
      case 'French':
        return 'fr';
      case 'Portuguese':
        return 'pt';
      case 'German':
        return 'de';
      default:
        return 'en';
    }
  }

  /// Function to save language selection in SharedPreferences
  Future<void> completeLanguageSelection() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('hasSelectedLanguage', true);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF4169E1).withOpacity(0.76),
        leading: CustomBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icons.arrow_back_ios_outlined,
          btnColor: Colors.white,
          iconSize: 24,
        ),
        title: regularText(
          title: languageProvider.translate('languages'),
          textSize: 24,
          textColor: Colors.white,
          textWeight: FontWeight.w400,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CustomTile(
                tileTitle: languageNames,
                tileColor: Colors.white70,
                tileLeading: List.generate(
                  countriesFlag.length,
                      (index) => CircleAvatar(
                    backgroundImage: AssetImage(countriesFlag[index]),
                  ),
                ),
                selectedValue: _selectedValue,
                onChanged: _onChanged,
              ),
            ),
            GestureDetector(
              onTap: () async {
                // interstitialAdController.checkAndShowAdOnVisit();
                if (_selectedValue != null) {
                  // Save language selection to SharedPreferences
                  await completeLanguageSelection();

                  // Navigate to HomeScreen after selection
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SpellPronounce()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(languageProvider.translate('language_selected_prompt')),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0XFF4169E1).withOpacity(0.76),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: regularText(
                    title: languageProvider.translate('next'),
                    textColor: Colors.white,
                    textSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

