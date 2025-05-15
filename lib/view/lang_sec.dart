import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/lang_controller.dart';


class LangSecSecreen extends StatefulWidget {
  const LangSecSecreen({super.key});

  @override
  State<LangSecSecreen> createState() => _LangSecSecreenState();
}

class _LangSecSecreenState extends State<LangSecSecreen> {
  final LangController controller=Get.put(LangController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchDataLang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Screen' ,style: TextStyle(fontSize: 16, ),),
        centerTitle: true,
      ),
      body: Column(
        children: [
         Expanded(
           child: ListView.builder(
               itemCount: controller.LangCat.length,
               itemBuilder: (context, index){
                 final itemData = controller.LangCat[index];
             return ListTile(
               title: Text(itemData.german ?? "No data available"),
             );
           }),
         )
        ],
      ),
    );
  }
}


