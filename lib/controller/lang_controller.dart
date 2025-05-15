import 'package:get/get.dart';
import 'package:mnh/models/langModel.dart';
import 'package:mnh/widgets/db_handler.dart';

class LangController extends GetxController{

  final DBHandler dbHandler = DBHandler();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDataLang();


  }

  var LangCat = <LangModel>[].obs;

  Future<void> fetchDataLang() async{
    try{
      await dbHandler.initDatabase();
      LangCat.value = await dbHandler.fetchDataCat();

    }catch(e){
      print("error: $e");
    }
  }

}
