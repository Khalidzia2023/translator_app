
class SelectLangModel{
  final String english;
  final String urdu;
  final String arabic;
  final String hindi;
  final String spanish;
  final String german;
  final String italian;
  SelectLangModel({
    required this.english,
    required this.urdu,
    required this.arabic,
    required this.hindi,
    required this.german,
    required this.italian,
    required this.spanish,
});


  SelectLangModel.fromMap(Map<String, dynamic> changeLang):
      english = changeLang['English'],
      urdu = changeLang['Urdu'],
      arabic = changeLang['Arabic'],
      hindi= changeLang['Hindi'],
      german = changeLang['German'],
      spanish = changeLang['Spanish'],
      italian = changeLang['Italian'];

String? getTranslation(String language) {
  switch (language) {
    case 'English':
      return english ?? '';
    case 'Urdu':
      return urdu;
    case 'Arabic':
      return arabic;
    case 'Hindi':
      return hindi;
    case 'Spanish':
      return spanish;
    case 'German':
      return german;
    case 'Italian':
      return italian;
    default:
      return '';
  }}}



