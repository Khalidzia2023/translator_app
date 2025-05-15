

class PhrasesModel{
  final int category_id;
  final String name;
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



  PhrasesModel( {
   required this.name,
    required this.category_id,
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


  PhrasesModel.fromMap(Map<String, dynamic> languagePhrase, ):
        name = languagePhrase['name'] ?? '',
        category_id=languagePhrase['category_id']??0,
        english = languagePhrase['English'] ?? "",
        afrikaans = languagePhrase['Afrikaans'] ?? "",
        albanian = languagePhrase['Albanian']?? "",
        amharic = languagePhrase['Amharic']?? "",
        arabic = languagePhrase['Arabic']?? "",
        armenian = languagePhrase['Armenian']?? "",
        azeerbaijani = languagePhrase['Azeerbaijani']?? "",
        basque = languagePhrase['Basque']?? "",
        belarusian = languagePhrase['Belarusian']?? "",
        bengali = languagePhrase['Bengali']?? "",
        bosnian = languagePhrase['Bosnian']?? "",
        bulgarian = languagePhrase['Bulgarian']?? "",
        catalan = languagePhrase['Catalan']?? "",
        cebuano = languagePhrase['Cebuano']?? "",
        chineseSimplified = languagePhrase['ChineseSimplified']?? "",
        chineseTraditional = languagePhrase['ChineseTraditional']?? "",
        croatian = languagePhrase['Croatian']?? "",
        czech = languagePhrase['Czech']?? "",
        danish = languagePhrase['Danish']?? "",
        dutch = languagePhrase['Dutch']?? "",
        esperanto = languagePhrase['Esperanto']?? "",
        estonian = languagePhrase['Estonian']?? "",
        finnish = languagePhrase['Finnish']?? "",
        french = languagePhrase['French']?? "",
        frisian = languagePhrase['Frisian']?? "",
        galician = languagePhrase['Galician']?? "",
        georgian = languagePhrase['Georgian']?? "",
        german = languagePhrase['German']?? "",
        greek = languagePhrase['Greek']?? "",
        gujarati = languagePhrase['Gujarati']?? "",
        haitian = languagePhrase['Haitian']?? "",
        hausa = languagePhrase['Hausa']?? "",
        hawaiian = languagePhrase['Hawaiian']?? "",
        hebrew = languagePhrase['Hebrew']?? "",
        hindi = languagePhrase['Hindi']?? "",
        hmong = languagePhrase['Hmong']?? "",
        hungarian = languagePhrase['Hungarian']?? "",
        icelandic = languagePhrase['Icelandic']?? "",
        indonesian = languagePhrase['Indonesian']?? "",
        irish = languagePhrase['Irish']?? "",
        italian = languagePhrase['Italian']?? "",
        japanese = languagePhrase['Japanese']?? "",
        javanese = languagePhrase['Javanese']?? "",
        kannada = languagePhrase['Kannada']?? "",
        kazakh = languagePhrase['Kazakh']?? "",
        khmer = languagePhrase['Khmer']?? "",
        koreanNK = languagePhrase['KoreanNK']?? "",
        koreanSK = languagePhrase['KoreanSK']?? "",
        kurdish = languagePhrase['Kurdish']?? "",
        kyrgyz = languagePhrase['Kyrgyz']?? "",
        lao = languagePhrase['Lao']?? "",
        latin = languagePhrase['Latin']?? "",
        latvian = languagePhrase['Latvian']?? "",
        lithuanian = languagePhrase['Lithuanian']?? "",
        luxembourgish = languagePhrase['Luxembourgish']?? "",
        macedonian = languagePhrase['Macedonian']?? "",
        malagasy = languagePhrase['Malagasy']?? "",
        malay = languagePhrase['Malay']?? "",
        malayalam = languagePhrase['Malayalam']?? "",
        maltese = languagePhrase['Maltese']?? "",
        maori = languagePhrase['Maori']?? "",
        marathi = languagePhrase['Marathi']?? "",
        mongolian = languagePhrase['Mongolian']?? "",
        myanmarBurmese = languagePhrase['MyanmarBurmese']?? "",
        nepali = languagePhrase['Nepali']?? "",
        norwegian = languagePhrase['Norwegian']?? "",
        nyanjaChichewa = languagePhrase['NyanjaChichewa']?? "",
        pashto = languagePhrase['Pashto']?? "",
        persian = languagePhrase['Persian']?? "",
        polish = languagePhrase['Polish']?? "",
        portuguese = languagePhrase['Portuguese']?? "",
        punjabi = languagePhrase['Punjabi']?? "",
        romanian = languagePhrase['Romanian']?? "",
        russian = languagePhrase['Russian']?? "",
        samoan = languagePhrase['Samoan']?? "",
        scotsGaelic = languagePhrase['ScotsGaelic']?? "",
        serbian = languagePhrase['Serbian']?? "",
        sesotho = languagePhrase['Sesotho']?? "",
        shona = languagePhrase['Shona']?? "",
        sindhi = languagePhrase['Sindhi']?? "",
        sinhala = languagePhrase['Sinhala']?? "",
        slovak = languagePhrase['Slovak']?? "",
        slovenian = languagePhrase['Slovenian']?? "",
        somali = languagePhrase['Somali']?? "",
        spanish = languagePhrase['Spanish']?? "",
        sundanese = languagePhrase['Sundanese']?? "",
        swahili = languagePhrase['Swahili']?? "",
        swedish = languagePhrase['Swedish']?? "",
        tagalog = languagePhrase['Tagalog']?? "",
        tajik = languagePhrase['Tajik']?? "",
        tamil = languagePhrase['Tamil']?? "",
        telugu = languagePhrase['Telugu']?? "",
        thai = languagePhrase['Thai']?? "",
        turkish = languagePhrase['Turkish']?? "",
        ukrainian = languagePhrase['Ukrainian']?? "",
        urdu = languagePhrase['Urdu']?? "",
        uzbek = languagePhrase['Uzbek']?? "",
        vietnamese = languagePhrase['Vietnamese']?? "",
        welsh = languagePhrase['Welsh']?? "",
        xhosa = languagePhrase['Xhosa']?? "",
        yiddish = languagePhrase['Yiddish']?? "",
        yoruba = languagePhrase['Yoruba']?? "",
        zulu = languagePhrase['Zulu']?? "";

}