import 'package:get/get.dart';
import 'package:mnh/models/languageModel.dart';
import 'package:mnh/models/phrase_model.dart';
import '../db_helper.dart';

class categoryController extends GetxController{
  final DbHelper dbHelper = DbHelper();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
    fetchPhrases();


  }

  var categories=<LanguageModel>[].obs;
  var phrases = <PhrasesModel>[].obs;

  Future<void> fetchData() async{

    try{
      await dbHelper.initDatabase();
      categories.value = await dbHelper.fetchCategory();
    }catch(e){
      print("Error: $e");
    }
  }

  Future<void> fetchPhrases() async{
    try{
      await dbHelper.initDatabase();
      phrases.value = await dbHelper.fetchPhrases();
    } catch(e){
      print("Error: $e");
    }
  }



}
