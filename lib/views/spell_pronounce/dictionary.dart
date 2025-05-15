import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/spell_pronounce/services_dict/dict_model.dart';
import 'package:mnh/views/spell_pronounce/services_dict/services.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import '../../ads_manager/banner_cnrtl.dart';
import '../../ads_manager/interstitial_contrl.dart';
import '../../ads_manager/native_as.dart';
import '../../ads_manager/openApp_controller.dart';
import '../../translator/controller/translate_contrl.dart';
import '../../widgets/back_button.dart';

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
  State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  final MyTranslationController translationController = Get.put(MyTranslationController());
  final interstitialAdController = Get.put(InterstitialAdController());
  final NativeAdController nativeAdController = Get.put(NativeAdController());
  final OpenAppAdController openAppAdController = Get.put(OpenAppAdController());

  bool _showAd = true; // Controls whether to show native ad or shimmer
  bool _isCooldown = false;
  bool _isTextAvailable = false;
  bool _isAdVisible = true;
  DictionaryModel? myDictionaryModel;
  bool isLoading = false;
  bool hasSearched = false;
  bool isLoad = false;
  bool isSearchPerformed = false; // Tracks if search was performed
  String noDataFound = "No word found!!\nCheck your word again";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ad closed callback
    interstitialAdController.onAdClosed = () {
      setState(() {
        _showAd = true;
      });
      print("=========> Ad was closed, set _showAd to true");
    };
    // Show initial ad
    interstitialAdController.showAd();
  }

  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> handleSpeechToText(String languageCode) async {
    if (_isCooldown) {
      Fluttertoast.showToast(
        msg: "You tapped more than once. Please wait a moment.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final internetAvailable = await isInternetAvailable();
    if (!internetAvailable) {
      Fluttertoast.showToast(
        msg: "Internet is weak or not available. Please check your connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    try {
      setState(() => _isCooldown = true);
      await translationController.startSpeechToText(languageCode);
      setState(() {
        _isTextAvailable = true;
      });
    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isCooldown = false);
    }
  }

  // Fetch data for searched word
  searchContain(String word) async {
    setState(() {
      isLoading = true;
      hasSearched = true;
      isLoad = true;
      isSearchPerformed = true;
    });
    try {
      myDictionaryModel = await APIservices.fetchData(word);
      setState(() {});
    } catch (e) {
      myDictionaryModel = null;
      noDataFound = "Meaning can't be found";
    } finally {
      setState(() {
        isLoading = false;
        // When data is loaded, hide ad
        _showAd = false;
      });
    }
  }

  // Reset the search
  resetScreen() {
    setState(() {
      myDictionaryModel = null;
      isLoading = false;
      hasSearched = false;
      isSearchPerformed = false;
      searchController.clear();
      _isTextAvailable = false;
    });
  }

  // Show meanings or handle connectivity issues
  findMeanings()  {
    if (myDictionaryModel != null) {
      // Logic if needed
    } else {
      Fluttertoast.showToast(
          msg: 'This word is not in your dictionary'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // If keyboard closes, show ad again
    if (!isKeyboardOpen && !_showAd) {
      setState(() {
        _showAd = true;
        print("=========> Keyboard closed, setting _showAd to true");
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
        leading: CustomBackButton(
            iconSize: 24,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back_ios_outlined,
            btnColor: Colors.white),
        title: const Text(
          "Dictionary",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar:
      openAppAdController.adAlreadyShown || isKeyboardOpen
          ? SizedBox()
          : hasSearched || isSearchPerformed
         ? SizedBox()
          : Container(
        height: MediaQuery.of(context).size.height * 0.45,
        margin: EdgeInsets.all(5),
        child: _isAdVisible && nativeAdController.isAdReady
            ? nativeAdController.adWidget.value
            : Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
      // Container(
      //   height: MediaQuery.of(context).size.height * 0.45,
      //   margin: EdgeInsets.all(5),
      //   child: (openAppAdController.adAlreadyShown || isKeyboardOpen)
      //       ? hasSearched || isSearchPerformed?Text("hhhhhh"): SizedBox()
      //   // SizedBox(
      //   //   child: hasSearched || isSearchPerformed ? findMeanings() : SizedBox(),
      //   // )
      //       : _isAdVisible && nativeAdController.isAdReady
      //       ? nativeAdController.adWidget.value
      //       : Shimmer.fromColors(
      //     baseColor: Colors.grey[300]!,
      //     highlightColor: Colors.grey[100]!,
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         height: 100,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(8.0),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search the word here",
                prefixIcon: _isTextAvailable
                    ? null
                    : Icon(Icons.search, color: Color(0XFF4169E1)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: micSpeak(
                  textController: searchController,
                  onTextUpdated: () {
                    setState(() {
                      _isTextAvailable = searchController.text.trim().isNotEmpty;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _isTextAvailable = value.trim().isNotEmpty;
                });
              },
              onSubmitted: (value) {
                String firstWord = value.trim().split(' ').first;
                if (firstWord.isNotEmpty) {
                  searchContain(firstWord);
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isSearchPerformed ? resetScreen : null,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                      if (!isSearchPerformed) {
                        return Colors.grey.shade400; // Gray when disabled
                      }
                      return Color(0XFF4169E1).withOpacity(.76);
                    }),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _isTextAvailable || searchController.text.trim().isNotEmpty
                      ? () async {
                    String firstWord = searchController.text.trim().split(' ').first;
                    await searchContain(firstWord);
                    findMeanings();
                  } : null,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey.shade400;
                      }
                      return Color(0XFF4169E1).withOpacity(.76);
                    }),
                  ),
                  child: const Text(
                    "Find Meaning",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!isSearchPerformed || myDictionaryModel == null)
              Image.asset(
                AppIcons.dictIcon1,
                color: Color(0XFF4169E1).withOpacity(0.26),
                scale: 4,
              ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (myDictionaryModel != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          'Result: ${myDictionaryModel!.word}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue),
                        ),
                        Spacer(),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Volume button action
                            },
                            child: VolumeBtnDic(
                                iconColor: Colors.white,
                                textToSpeak: myDictionaryModel!.word),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      myDictionaryModel!.phonetics.isNotEmpty
                          ? myDictionaryModel!.phonetics[0].text ?? ""
                          : "",
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: myDictionaryModel!.meanings.length,
                        itemBuilder: (context, index) {
                          return showMeaning(myDictionaryModel!.meanings[index]);
                        },
                      ),
                    ),
                  ],
                ),
              )
            else if (hasSearched)
                Center(
                  child: Text(
                    noDataFound,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  showMeaning(Meaning meaning) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border(bottom: BorderSide(color: Colors.grey, width: 2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
              if (meaning.definitions.isNotEmpty) ...[
                const Text(
                  "Definitions:",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: meaning.definitions.map((definition) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text(
                        "• ${definition.definition} ",
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    );
                  }).toList(),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VolumeBtnDic(
                      iconColor: Colors.blueGrey,
                      textToSpeak: meaning.definitions
                          .map((definition) => definition.definition)
                          .join("\n\n")),
                  CopyBtnDic(
                      iconColor: Colors.blueGrey,
                      contentToCopy: meaning.definitions
                          .map((definition) => definition.definition)
                          .join("\n\n")),
                ],
              )
            ],
          ),
        ),
        if (meaning.synonyms.isNotEmpty || meaning.antonyms.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border(bottom: BorderSide(color: Colors.grey, width: 2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                wordRelation("Synonyms", meaning.synonyms),
                wordRelation("Antonyms", meaning.antonyms),
              ],
            ),
          ),
      ],
    );
  }

  wordRelation(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "$title:",
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16, color: Colors.blue),
          ),
          Text(
            setList!.toSet().join(", "),
            maxLines: null,
            softWrap: true,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              VolumeBtnDic(
                  iconColor: Colors.blueGrey,
                  textToSpeak: setList.toSet().join(", ")),
              CopyBtnDic(
                  iconColor: Colors.blueGrey,
                  contentToCopy: setList.toSet().join(", ")),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}


class micSpeak extends StatefulWidget {
  final TextEditingController textController;
  final Function onTextUpdated;
  const micSpeak({super.key, required this.textController, required this.onTextUpdated});

  @override
  State<micSpeak> createState() => _micSpeakState();
}

class _micSpeakState extends State<micSpeak> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isCooldown = false;
  static const MethodChannel _methodChannel =
  MethodChannel('com.example.mnh/speech_Text');

  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> startSpeechToText(String languageISO) async {
    if (_isCooldown || _isListening) return;

    final internetAvailable = await isInternetAvailable();
    if (!internetAvailable) {
      Fluttertoast.showToast(
        msg: "Internet is weak or not available. Please check your connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    try {
      setState(() {
        _isListening = true;
        _isCooldown = true;
      });

      final result = await _methodChannel.invokeMethod(
        'getTextFromSpeech',
        {'languageISO': languageISO},
      );

      if (result != null && result.isNotEmpty) {
        widget.textController.text = result;
        widget.onTextUpdated();
      }

      await _speech.listen(
        onResult: (speechResult) {
          setState(() {
            widget.textController.text = speechResult.recognizedWords;
            widget.onTextUpdated();
          });
        },
        listenFor: const Duration(seconds: 10),
        cancelOnError: true,
      );
    } catch (e) {
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isListening = false;
        _isCooldown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => startSpeechToText('en-US'),
      child: Image.asset(AppIcons.micIcon, color: Colors.blue, scale: 23),
    );
  }
}




class CopyBtnDic extends StatelessWidget {
  final Color iconColor;
  final String contentToCopy; // New parameter

  CopyBtnDic({required this.iconColor, required this.contentToCopy});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.copy, color: iconColor, size: 24,),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: contentToCopy));
        Fluttertoast.showToast(msg: 'Text copied to clipboard');
      },
    );
  }
}


/// Volume Button - Speaks out text

class VolumeBtnDic extends StatefulWidget {
  final Color iconColor;
  final String textToSpeak;

  const VolumeBtnDic({required this.iconColor, required this.textToSpeak, Key? key}) : super(key: key);

  @override
  _VolumeBtnDicState createState() => _VolumeBtnDicState();
}

class _VolumeBtnDicState extends State<VolumeBtnDic> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false; // Track if text is currently being spoken

  Future<void> _speak() async {
    await flutterTts.stop(); // Stop any ongoing speech
    if (widget.textToSpeak.isNotEmpty) {
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.speak(widget.textToSpeak);

      // Wait for the text-to-speech to finish
      await flutterTts.awaitSpeakCompletion(true);

      // Once speaking is done, mark it as not speaking
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Future<void> _stopSpeech() async {
    await flutterTts.stop(); // Stop speech
    setState(() {
      _isSpeaking = false; // Mark as stopped
    });
  }

  @override
  void dispose() {
    flutterTts.stop(); // Stop speech when navigating away
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isSpeaking ? Icons.volume_off : Icons.volume_up, // Change icons based on speaking state
        color: widget.iconColor,
        size: 26,
      ),
      onPressed: () {
        if (_isSpeaking) {
          // If currently speaking, stop the speech
          _stopSpeech();
        } else {
          // Start speaking if not already speaking
          setState(() {
            _isSpeaking = true; // Mark as speaking immediately when starting TTS
          });
          _speak();
        }
      },
    );
  }
}



/// Share Button - Shares text using share_plus
class ShareBtnDic extends StatelessWidget {
  final Color iconColor;
  final String textToShare;

  ShareBtnDic({required this.iconColor, required this.textToShare});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share, color: iconColor, size: 20),
      onPressed: () {
        if (textToShare.trim().isNotEmpty) {
          Share.share(textToShare);
          // Fluttertoast.showToast(msg: 'share the text');
        } else {
          Fluttertoast.showToast(msg: 'No text to share');
        }
      },
    );
  }
}
