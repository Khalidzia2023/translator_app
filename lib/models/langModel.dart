
class LangModel{

  final String? english;
  final String? urdu;
  final String? arabic;
  final String? hindi;
  final String? spanish;
  final String? german;
  final String? italian;
  final String? korean;
  final String? chinese;


LangModel({
  this.english,
  this.urdu,
  this.arabic,
  this.hindi,
  this.spanish,
  this.german,
  this.italian,
  this.korean,
  this.chinese,
});

  LangModel.fromMap(Map<String, dynamic> LangDB) :
        english = LangDB['English'] ?? "",
        urdu = LangDB['Urdu'] ?? "",
        arabic = LangDB['Arabic'] ?? "",
        hindi = LangDB['Hindi'] ?? "",
        spanish = LangDB['Spanish'] ?? "",
        german = LangDB['German'] ?? "",
        italian = LangDB['Italian'] ?? "",
        korean = LangDB['Korean'] ?? "",
        chinese = LangDB['Chinese'] ?? "";

}