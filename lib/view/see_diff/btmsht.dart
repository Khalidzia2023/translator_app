
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'db_sel.dart'; // Import your database helper
import 'model_sel.dart'; // Import your model
import 'controller_sel.dart'; // Import your controller

class LanguageSelector extends StatefulWidget {
  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final List<String> languages = ["English", "Urdu", "Arabic", "Hindi"];
  final BTMController btmController = Get.put(BTMController());

  String? firstContainerLanguage = "English";
  String? secondContainerLanguage = "English";

  // Function to get translations based on language
  String _getTranslation(BtmModel model, String language) {
    switch (language) {
      case "Urdu":
        return model.urdu.isNotEmpty ? model.urdu : "No Translation";
      case "Arabic":
        return model.arabic.isNotEmpty ? model.arabic : "No Translation";
      case "Hindi":
        return model.hindi.isNotEmpty ? model.hindi : "No Translation";
      default:
        return model.english.isNotEmpty ? model.english : "No Translation";
    }
  }


  void _showLanguageSelector({
    required String currentLanguage,
    required void Function(String) onLanguageSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Select the language you want',
                style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.w400),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(languages[index]),
                    trailing: currentLanguage == languages[index]
                        ? Icon(Icons.check_circle, color: Colors.blue, size: 15)
                        : null,
                    onTap: () {
                      onLanguageSelected(languages[index]);
                      Navigator.pop(context); // Close the modal
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Language Selector"),
        backgroundColor: Colors.brown,
      ),
      body: Obx(() {
        if (btmController.categor.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => _showLanguageSelector(
                      currentLanguage: firstContainerLanguage!,
                      onLanguageSelected: (selected) {
                        setState(() {
                          firstContainerLanguage = selected;
                        });
                      },
                    ),
                    child: Container(
                      height: 40,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                        color: Colors.blueGrey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            firstContainerLanguage!,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => _showLanguageSelector(
                      currentLanguage: secondContainerLanguage!,
                      onLanguageSelected: (selected) {
                        setState(() {
                          secondContainerLanguage = selected;
                        });
                      },
                    ),
                    child: Container(
                      height: 40,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                        color: Colors.blueGrey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            secondContainerLanguage!,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                itemCount: btmController.categor.length,
                itemBuilder: (context, index) {
                  final model = btmController.categor[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.flag,
                        color: Colors.deepOrange.shade400,
                      ),
                      title: Text(
                        _getTranslation(model, firstContainerLanguage!),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        _getTranslation(model, secondContainerLanguage!),
                        style: TextStyle(color: Colors.white54),
                      ),
                      tileColor: Colors.blueGrey.shade400,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

