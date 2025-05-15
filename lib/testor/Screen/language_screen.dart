import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnh/testor/controller/cont_lang.dart';
import 'package:mnh/widgets/text_widget.dart';

import 'languageContent_screen.dart';
class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final SelectLangController controller = Get.put(SelectLangController());
  int _selectedIndex = -1;

  List<String> languageNames = [
    'English',
    'Urdu',
    'Spanish',
    'German',
    'Italian',
    'Arabic',
    'Hindi'
  ];

  @override
  void initState() {
    super.initState();
    controller.getDataSet(); // Initialize database data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 40),
          regularText(
            title: 'Select the language',
            textWeight: FontWeight.w600,
            textSize: 18,
            textColor: Colors.blue,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languageNames.length,
              itemBuilder: (context, index) {
                final translation = controller.catLang.isNotEmpty
                    ? controller.catLang[0]
                    : null; // Get the first item from the list

                return GestureDetector(
                  onTap: () {
                    // On tap, navigate to the next screen
                    controller.updateTranslation(languageNames[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LanguageContentScreen(
                          language: languageNames[index], // Pass selected language
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black, width: 2),
                        color: _selectedIndex == index
                            ? Colors.blueGrey
                            : Colors.white,
                      ),
                      child: ListTile(
                        title: regularText(
                          title: languageNames[index],
                          textWeight: FontWeight.w600,
                          textSize: 16,
                          textColor: _selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                        subtitle: regularText(
                          title: translation?.getTranslation(languageNames[index]) ?? '',
                          textWeight: FontWeight.w300,
                          textSize: 14,
                          textColor: Colors.grey,
                        ),
                        leading: Icon(
                          Icons.self_improvement_rounded,
                          color: Colors.blue,
                        ),
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
  }
}
