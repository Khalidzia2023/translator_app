import 'package:audioplayers/audioplayers.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mnh/translator/controller/translate_contrl.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/languages/provider/language_provider.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class SPeakTest extends StatefulWidget {
  const SPeakTest({super.key});

  @override
  State<SPeakTest> createState() => _SPeakTestState();
}

class _SPeakTestState extends State<SPeakTest> {
  final MyTranslationController MytranslationController = Get.put(MyTranslationController());
  final TtsServiceTest _ttsService = TtsServiceTest();
  final String chineseText = 'Good morning, I hope the code is now written'; // Chinese text to speak.

  double _pitchSlider = 1.0;
  double _speechSlider = 1.0;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
  }

  void _speak() {
    _ttsService.speakText(chineseText, 'zh', _pitchSlider, _speechSlider); // Passing the Chinese text with its language code 'zh'
  }

  void _showLanguageSelect({
    required String currentLang,
    required void Function(String?) onLangSelect,
    required bool isFirstContainer,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final languageProvider = Provider.of<LanguageProvider>(context);
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      languageProvider.translate('Select the language you want'),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: languageProvider.translate('Search languages...'),
                          hintStyle: TextStyle(color: Colors.grey),
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
                          // String language = MytranslationController.languageCodes.keys.elementAt(index);
                          String code = MytranslationController.languageFlags[language]!;
                          // String code = MytranslationController.languageCodes[language]!;

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
                                  title: Text(language, style: TextStyle(fontSize: 16)),
                                  dense: true,
                                  leading: CountryFlag.fromCountryCode(
                                    code,
                                    height: 25,
                                    shape: Circle(),
                                  ),
                                  trailing: currentLang == language
                                      ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                                      : null,
                                  onTap: () async {
                                    onLangSelect(language);
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TTS Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showLanguageSelect(
                        currentLang: MytranslationController.firstContainerLanguage.value,
                        onLangSelect: (selected) {
                          setState(() {
                            String selectedLanguage = selected!;
                            MytranslationController.firstContainerLanguage.value = selectedLanguage;
                            MytranslationController.controller.clear();
                          });
                        },
                        isFirstContainer: true,
                      );
                    },
                    child: LanguageContainer(
                      containerColor: Color(0XFF4169E1).withOpacity(0.76),
                      language: MytranslationController.firstContainerLanguage.value,
                      countryCode: MytranslationController.languageFlags[MytranslationController.firstContainerLanguage.value]!,
                      // countryCode: MytranslationController.languageCodes[MytranslationController.firstContainerLanguage.value]!,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 270,
              child: Column(
                children: [
                  regularText(title: 'Adjust Speech Settings'),
                  ListTile(
                    title: Text('Pitch'),
                    trailing: Text(_pitchSlider.toStringAsFixed(2)),
                  ),
                  Slider(
                    value: _pitchSlider,
                    min: 0.5,
                    max: 2.0,
                    divisions: 20,
                    label: _pitchSlider.toStringAsFixed(2),
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setState(() {
                        _pitchSlider = value;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Speech Rate'),
                    trailing: Text(_speechSlider.toStringAsFixed(2)),
                  ),
                  Slider(
                    value: _speechSlider,
                    min: 0.5,
                    max: 2.0,
                    divisions: 20,
                    label: _speechSlider.toStringAsFixed(2),
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setState(() {
                        _speechSlider = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Text(chineseText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              child: const Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}

class TtsServiceTest {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();

  final List<String> _flutterSupportedLanguages = [
    'pt', 'ru', 'yo', 'az', 'ky', 'zu', 'yi', 'xh', 'uz', 'tg', 'so',
    // added 'zh' for Chinese Language
    'zh',
    'sl', 'sd', 'sn', 'st', 'gd', 'sm', 'fa', 'ps', 'ny', 'mn', 'mi',
    'mt', 'mg', 'mk', 'lb', 'lo', 'ku', 'kk', 'ga', 'id', 'is', 'hu',
    'hmn', 'he', 'ha', 'ht', 'ka', 'fy', 'eo', 'ceb', 'be', 'hy',
  ];

  bool _isInitialized = false;

  Future<void> init() async {
    _isInitialized = true;
    await _flutterTts.setLanguage("en-US");
  }

  Future<void> speakText(String text, String languageCode, double pitch, double speechRate) async {
    if (text.isEmpty) {
      Fluttertoast.showToast(
        msg: "No text to speak",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Check if the language code is supported by Flutter TTS
    if (_flutterSupportedLanguages.contains(languageCode)) {
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setPitch(pitch);
      await _flutterTts.setSpeechRate(speechRate);
      await _flutterTts.speak(text);
    } else {
      List<String> textChunks = _splitTextIntoChunks(text, 200);
      for (String chunk in textChunks) {
        await _playAudio(chunk, languageCode, speechRate);
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  Future<void> _playAudio(String text, String languageCode, double speechRate) async {
    String url =
        'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q='
        '${Uri.encodeComponent(text)}&tl=$languageCode';

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setPlaybackRate(speechRate);
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to play audio: TimeoutException',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  List<String> _splitTextIntoChunks(String text, int maxLength) {
    List<String> chunks = [];
    for (int i = 0; i < text.length; i += maxLength) {
      int end = (i + maxLength < text.length) ? i + maxLength : text.length;
      chunks.add(text.substring(i, end));
    }
    return chunks;
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      await _flutterTts.stop();
    } catch (e) {
      print('Failed to stop audio: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      print('Failed to dispose audio player: $e');
    }
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
    double screenWidth = MediaQuery.of(context).size.width;
    String displayLanguage = language.length > 7 ? '${language.substring(0, 7)}...' : language;
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: containerColor,
      ),
      child: Row(
        spacing: 6,
        children: [
          6.asWidthBox,
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
