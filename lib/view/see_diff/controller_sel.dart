
import 'package:get/get.dart';
import 'package:mnh/view/see_diff/model_sel.dart';

import 'db_sel.dart';

class BTMController extends GetxController{
  final DBbtm dbBtm = DBbtm();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchBTMData();
  }


  var categor = <BtmModel>[].obs;

  Future<void> fetchBTMData() async {
    try {
      await dbBtm.initDatabase();
      categor.value = await dbBtm.getDataher();
      print("Fetched Data: ${categor.map((e) => e.english).toList()}");
    } catch (e) {
      print("Error: $e");
    }
  }


}