// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/text_widget.dart';

import '../new_test.dart';
import '../translator/controller/translate_contrl.dart';
import '../utils/app_icons.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'back_button.dart';
import 'custom_textBtn.dart';

class CustomMic extends StatefulWidget {
  final VoidCallback? onTap;
  const CustomMic({
    super.key,
    this.onTap,
  });

  @override
  State<CustomMic> createState() => _CustomMicState();
}

class _CustomMicState extends State<CustomMic> {
  final MyTranslationController translationController = Get.put(MyTranslationController());
  bool _isCooldown = false;

  // Future<bool> isInternetAvailable() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }

  Future<void> handleSpeechToText(String languageCode) async {
    if (_isCooldown) {
      Fluttertoast.showToast(
        msg: "You tapped more than once. Please wait a moment.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // final internetAvailable = await isInternetAvailable();
    //
    // if (!internetAvailable) {
    //   Fluttertoast.showToast(
    //     msg: "Internet is weak or not available. Please check your connection.",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //   );
    //   return;
    // }

    try {
      setState(() => _isCooldown = true);
      await translationController.startSpeechToText(languageCode);
    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isCooldown = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap ?? () {
        // final selectedLanguageCode =
        //     '${translationController.languageCodes[
        // translationController.firstContainerLanguage.value
        // ]}-US';
        handleSpeechToText('');
      },
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.14,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            color: Color(0XFF4169E1).withValues(alpha: .76),
        ),
        child: Image.asset(AppIcons.micIcon, color: Colors.white,scale: 23,),
      ),
    );
  }
}


class CustomMic2 extends StatefulWidget {
  final TextEditingController textController;
  const CustomMic2({super.key, required this.textController});

  @override
  State<CustomMic2> createState() => _CustomMic2State();
}

class _CustomMic2State extends State<CustomMic2> {

  final MyTranslationController translationController = Get.put(MyTranslationController());
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isCooldown = false;




  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print("Speech Status: $status");
      },
      onError: (error) {
        print("Speech Error: $error");
      },
    );
    if (!available) {
      Get.snackbar("Error", "Speech recognition is not available.");
    }
  }


  Future<void> _startListening(String languageCode) async {
    if (_isCooldown || _isListening) return;


    try {
      setState(() async{
        await translationController.startSpeechToText(languageCode);
        _isListening = true;
        _isCooldown = true;
      });

      await _speech.listen(
        onResult: (result) {
          setState(() {
            widget.textController.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 10),
        cancelOnError: true,
      );
    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        _startListening;
      },
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.14,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          color: const Color(0XFF4169E1).withOpacity(0.76),
        ),
        child: Image.asset(AppIcons.micIcon, color: Colors.white, scale: 23),
      ),
    );
  }
}


