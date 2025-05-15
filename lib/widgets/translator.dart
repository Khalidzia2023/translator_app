import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:translator/translator.dart';

class GoogleTranslatorScreen extends StatefulWidget {
  const GoogleTranslatorScreen({Key? key}) : super(key: key);

  @override
  State<GoogleTranslatorScreen> createState() => _GoogleTranslatorScreenState();
}

class _GoogleTranslatorScreenState extends State<GoogleTranslatorScreen> {
  String originCountry = "United States";
  String originLanguage = "English";
  String originCode = "en";
  String destinationCountry = "India";
  String destinationLanguage = "Hindi";
  String destinationCode = "hi";
  String output = "";
  TextEditingController textController = TextEditingController();

  final GoogleTranslator translator = GoogleTranslator();

  // Dynamic language mapping based on country
  String getLanguageCode(String countryCode) {
    Map<String, String> countryToLanguageMap = {
      'US': 'en', // United States -> English
      'IN': 'hi', // India -> Hindi
      'DE': 'de', // Germany -> German
      'FR': 'fr', // France -> French
      'JP': 'ja', // Japan -> Japanese
      'CN': 'zh', // China -> Chinese
      'ES': 'es', // Spain -> Spanish
      'IT': 'it', // Italy -> Italian
      'RU': 'ru', // Russia -> Russian
      'PK': 'ur',
      'SA': 'ar'
    };
    return countryToLanguageMap[countryCode] ?? 'en'; // Default to English
  }

  String getLanguageName(String countryCode) {
    Map<String, String> countryToLanguageNameMap = {
      'US': 'English',
      'IN': 'Hindi',
      'DE': 'German',
      'FR': 'French',
      'JP': 'Japanese',
      'CN': 'Chinese',
      'ES': 'Spanish',
      'IT': 'Italian',
      'RU': 'Russian',
      'PK': 'Pakistan',
      'SA': 'Saudia Arabia'
    };
    return countryToLanguageNameMap[countryCode] ?? 'English'; // Default to English
  }

  void translateText() async {
    String input = textController.text;

    if (input.isEmpty) {
      setState(() {
        output = "Please enter text to translate.";
      });
      return;
    }

    try {
      var translation = await translator.translate(input, from: originCode, to: destinationCode);
      setState(() {
        output = translation.text;
      });
    } catch (e) {
      setState(() {
        output = "Translation failed: $e";
      });
    }
  }

  void pickCountry(bool isOrigin) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          if (isOrigin) {
            originCountry = country.name;
            originCode = getLanguageCode(country.countryCode);
            originLanguage = getLanguageName(country.countryCode);
          } else {
            destinationCountry = country.name;
            destinationCode = getLanguageCode(country.countryCode);
            destinationLanguage = getLanguageName(country.countryCode);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Translator',
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => pickCountry(true),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        originCountry,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward, color: Colors.indigo),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => pickCountry(false),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        destinationCountry,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "$originLanguage → $destinationLanguage",
              style: const TextStyle(fontSize: 16, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter text to translate",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: translateText,
              child: const Text("Translate"),
            ),
            const SizedBox(height: 20),
            Text(
              output,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
