
class LanguageModel{
  final String english;
  final String afrikaans;
  final String albanian;
  final String amharic;
  final String arabic;
  final String armenian;
  final String azeerbaijani;
  final String basque;
  final String belarusian;
  final String bengali;
  final String bosnian;
  final String bulgarian;
  final String catalan;
  final String cebuano;
  final String chineseSimplified;
  final String chineseTraditional;
  final String croatian;
  final String czech;
  final String danish;
  final String dutch;
  final String esperanto;
  final String estonian;
  final String finnish;
  final String french;
  final String frisian;
  final String galician;
  final String georgian;
  final String german;
  final String greek;
  final String gujarati;
  final String haitian;
  final String hausa;
  final String hawaiian;
  final String hebrew;
  final String hindi;
  final String hmong;
  final String hungarian;
  final String icelandic;
  final String indonesian;
  final String irish;
  final String italian;
  final String japanese;
  final String javanese;
  final String kannada;
  final String kazakh;
  final String khmer;
  final String koreanNK;
  final String koreanSK;
  final String kurdish;
  final String kyrgyz;
  final String lao;
  final String latin;
  final String latvian;
  final String lithuanian;
  final String luxembourgish;
  final String macedonian;
  final String malagasy;
  final String malay;
  final String malayalam;
  final String maltese;
  final String maori;
  final String marathi;
  final String mongolian;
  final String myanmarBurmese;
  final String nepali;
  final String norwegian;
  final String nyanjaChichewa;
  final String pashto;
  final String persian;
  final String polish;
  final String portuguese;
  final String punjabi;
  final String romanian;
  final String russian;
  final String samoan;
  final String scotsGaelic;
  final String serbian;
  final String sesotho;
  final String shona;
  final String sindhi;
  final String sinhala;
  final String slovak;
  final String slovenian;
  final String somali;
  final String spanish;
  final String sundanese;
  final String swahili;
  final String swedish;
  final String tagalog;
  final String tajik;
  final String tamil;
  final String telugu;
  final String thai;
  final String turkish;
  final String ukrainian;
  final String urdu;
  final String uzbek;
  final String vietnamese;
  final String welsh;
  final String xhosa;
  final String yiddish;
  final String yoruba;
  final String zulu;


  LanguageModel({
    required this.english,
    required this.afrikaans,
    required this.albanian,
    required this.amharic,
    required this.arabic,
    required this.armenian,
    required this.azeerbaijani,
    required this.basque,
    required this.belarusian,
    required this.bengali,
    required this.bosnian,
    required this.bulgarian,
    required this.catalan,
    required this.cebuano,
    required this.chineseSimplified,
    required this.chineseTraditional,
    required this.croatian,
    required this.czech,
    required this.danish,
    required this.dutch,
    required this.esperanto,
    required this.estonian,
    required this.finnish,
    required this.french,
    required this.frisian,
    required this.galician,
    required this.georgian,
    required this.german,
    required this.greek,
    required this.gujarati,
    required this.haitian,
    required this.hausa,
    required this.hawaiian,
    required this.hebrew,
    required this.hindi,
    required this.hmong,
    required this.hungarian,
    required this.icelandic,
    required this.indonesian,
    required this.irish,
    required this.italian,
    required this.japanese,
    required this.javanese,
    required this.kannada,
    required this.kazakh,
    required this.khmer,
    required this.koreanNK,
    required this.koreanSK,
    required this.kurdish,
    required this.kyrgyz,
    required this.lao,
    required this.latin,
    required this.latvian,
    required this.lithuanian,
    required this.luxembourgish,
    required this.macedonian,
    required this.malagasy,
    required this.malay,
    required this.malayalam,
    required this.maltese,
    required this.maori,
    required this.marathi,
    required this.mongolian,
    required this.myanmarBurmese,
    required this.nepali,
    required this.norwegian,
    required this.nyanjaChichewa,
    required this.pashto,
    required this.persian,
    required this.polish,
    required this.portuguese,
    required this.punjabi,
    required this.romanian,
    required this.russian,
    required this.samoan,
    required this.scotsGaelic,
    required this.serbian,
    required this.sesotho,
    required this.shona,
    required this.sindhi,
    required this.sinhala,
    required this.slovak,
    required this.slovenian,
    required this.somali,
    required this.spanish,
    required this.sundanese,
    required this.swahili,
    required this.swedish,
    required this.tagalog,
    required this.tajik,
    required this.tamil,
    required this.telugu,
    required this.thai,
    required this.turkish,
    required this.ukrainian,
    required this.urdu,
    required this.uzbek,
    required this.vietnamese,
    required this.welsh,
    required this.xhosa,
    required this.yiddish,
    required this.yoruba,
    required this.zulu,
  });

  LanguageModel.fromMap(Map<String, dynamic> dataBaseModel):
        // english = dataBaseModel['English'],
        english = dataBaseModel['English'],
        afrikaans = dataBaseModel['Afrikaans'],
        albanian = dataBaseModel['Albanian'],
        amharic = dataBaseModel['Amharic'],
        arabic = dataBaseModel['Arabic'],
        armenian = dataBaseModel['Armenian'],
        azeerbaijani = dataBaseModel['Azeerbaijani'],
        basque = dataBaseModel['Basque'],
        belarusian = dataBaseModel['Belarusian'],
        bengali = dataBaseModel['Bengali'],
        bosnian = dataBaseModel['Bosnian'],
        bulgarian = dataBaseModel['Bulgarian'],
        catalan = dataBaseModel['Catalan'],
        cebuano = dataBaseModel['Cebuano'],
       chineseSimplified = dataBaseModel['ChineseSimplified'],
       chineseTraditional = dataBaseModel['ChineseTraditional'],
       croatian = dataBaseModel['Croatian'],
       czech = dataBaseModel['Czech'],
       danish = dataBaseModel['Danish'],
       dutch = dataBaseModel['Dutch'],
       esperanto = dataBaseModel['Esperanto'],
       estonian = dataBaseModel['Estonian'],
       finnish = dataBaseModel['Finnish'],
       french = dataBaseModel['French'],
       frisian = dataBaseModel['Frisian'],
       galician = dataBaseModel['Galician'],
       georgian = dataBaseModel['Georgian'],
       german = dataBaseModel['German'],
       greek = dataBaseModel['Greek'],
       gujarati = dataBaseModel['Gujarati'],
       haitian = dataBaseModel['Haitian'],
       hausa = dataBaseModel['Hausa'],
       hawaiian = dataBaseModel['Hawaiian'],
       hebrew = dataBaseModel['Hebrew'],
       hindi = dataBaseModel['Hindi'],
       hmong = dataBaseModel['Hmong'],
        hungarian = dataBaseModel['Hungarian'],
        icelandic = dataBaseModel['Icelandic'],
        indonesian = dataBaseModel['Indonesian'],
        irish = dataBaseModel['Irish'],
        italian = dataBaseModel['Italian'],
        japanese = dataBaseModel['Japanese'],
        javanese = dataBaseModel['Javanese'],
        kannada = dataBaseModel['Kannada'],
        kazakh = dataBaseModel['Kazakh'],
        khmer = dataBaseModel['Khmer'],
        koreanNK = dataBaseModel['KoreanNK'],
        koreanSK = dataBaseModel['KoreanSK'],
        kurdish = dataBaseModel['Kurdish'],
        kyrgyz = dataBaseModel['Kyrgyz'],
        lao = dataBaseModel['Lao'],
        latin = dataBaseModel['Latin'],
        latvian = dataBaseModel['Latvian'],
        lithuanian = dataBaseModel['Lithuanian'],
        luxembourgish = dataBaseModel['Luxembourgish'],
        macedonian = dataBaseModel['Macedonian'],
        malagasy = dataBaseModel['Malagasy'],
        malay = dataBaseModel['Malay'],
        malayalam = dataBaseModel['Malayalam'],
        maltese = dataBaseModel['Maltese'],
        maori = dataBaseModel['Maori'],
        marathi = dataBaseModel['Marathi'],
        mongolian = dataBaseModel['Mongolian'],
        myanmarBurmese = dataBaseModel['MyanmarBurmese'],
        nepali = dataBaseModel['Nepali'],
        norwegian = dataBaseModel['Norwegian'],
        nyanjaChichewa = dataBaseModel['NyanjaChichewa'],
        pashto = dataBaseModel['Pashto'],
        persian = dataBaseModel['Persian'],
        polish = dataBaseModel['Polish'],
        portuguese = dataBaseModel['Portuguese'],
        punjabi = dataBaseModel['Punjabi'],
        romanian = dataBaseModel['Romanian'],
        russian = dataBaseModel['Russian'],
        samoan = dataBaseModel['Samoan'],
        scotsGaelic = dataBaseModel['ScotsGaelic'],
        serbian = dataBaseModel['Serbian'],
        sesotho = dataBaseModel['Sesotho'],
        shona = dataBaseModel['Shona'],
        sindhi = dataBaseModel['Sindhi'],
        sinhala = dataBaseModel['Sinhala'],
        slovak = dataBaseModel['Slovak'],
        slovenian = dataBaseModel['Slovenian'],
        somali = dataBaseModel['Somali'],
        spanish = dataBaseModel['Spanish'],
        sundanese = dataBaseModel['Sundanese'],
        swahili = dataBaseModel['Swahili'],
        swedish = dataBaseModel['Swedish'],
        tagalog = dataBaseModel['Tagalog'],
        tajik = dataBaseModel['Tajik'],
        tamil = dataBaseModel['Tamil'],
        telugu = dataBaseModel['Telugu'],
        thai = dataBaseModel['Thai'],
        turkish = dataBaseModel['Turkish'],
        ukrainian = dataBaseModel['Ukrainian'],
        urdu = dataBaseModel['Urdu'],
        uzbek = dataBaseModel['Uzbek'],
        vietnamese = dataBaseModel['Vietnamese'],
        welsh = dataBaseModel['Welsh'],
        xhosa = dataBaseModel['Xhosa'],
        yiddish = dataBaseModel['Yiddish'],
        yoruba = dataBaseModel['Yoruba'],
        zulu = dataBaseModel['Zulu'];

Map<String, Object?> toMap(){

  return{
    'english': english,
    'hindi': hindi,
    'arabic': arabic,
    'urdu': urdu,
    'spanish': spanish,
  };
}

}
