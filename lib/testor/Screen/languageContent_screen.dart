import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/cont_lang.dart';

class LanguageContentScreen extends StatelessWidget {
  final String language;

  LanguageContentScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    final SelectLangController controller = Get.find();

    // Check if we have data
    if (controller.catLang.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('$language Content'),
        ),
        body: Center(
          child: Text('No data available'),
        ),
      );
    }

    // Extract the translations for the selected language
    List<String> contentList = controller.catLang.map((entry) {
      return entry.getTranslation(language) ?? 'No content available';
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$language Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: contentList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 60,
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        contentList[index],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              // child: Text(
              //   contentList[index],
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              //   textAlign: TextAlign.justify,
              // ),
            );
          },
        ),
      ),
    );
  }
}
