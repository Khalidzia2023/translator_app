import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/category_contrl.dart';

class CategoryScreen extends StatefulWidget {
 CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categoryController controller=Get.put(categoryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.categories.length,
                itemBuilder:(context,index){
                final item = controller.categories[index];
                return Card(
                  child: Center(child: Text(item.hindi)),
                );
            }),
          ),
        ],
      )
    );
  }
}
