
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TtsService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  // Updated list of supported languages by Flutter TTS
  final List<String> _flutterSupportedLanguages = [
    'pt', 'ru', 'yo', 'az', 'ky', 'zu', 'yi', 'xh', 'uz', 'tg', 'so', 'sl', 'sd',
    'sn', 'st', 'gd', 'sm', 'fa', 'ps', 'ny', 'mn', 'mi', 'mt', 'mg', 'mk', 'lb',
    'lo', 'ku', 'kk', 'ga', 'id', 'is', 'hu', 'hmn', 'he', 'ha', 'ht', 'ka', 'fy',
    'eo', 'ceb', 'be', 'hy',    'zh',
  ];

  bool _isInitialized = false;

  // Initialize Flutter TTS
  Future<void> init() async {
    _isInitialized = true;
    await _flutterTts.setLanguage("en-US"); // Set default language
  }

  Future<void> speakText(String text, String languageCode, double pitch, double rate) async {
    if (text.isEmpty) {
      Fluttertoast.showToast(
        msg: "No text to speak",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

   //  Check if the language is supported by Flutter TTS
    /// <>
    if (_flutterSupportedLanguages.contains(languageCode)) {
      //
      // await setSpeechRate(rate);
      // if (pitch != null  && rate != null){
      //   await setSpeechRate(rate);
      //   await setPitch(pitch);}
      // // Fluttertoast.showToast(
      // //   msg: 'Playback rate adjusted to $rate',
      // //   toastLength: Toast.LENGTH_SHORT,
      // //   gravity: ToastGravity.BOTTOM,
      // // );
      // await _flutterTts.setLanguage(languageCode);
      // await _flutterTts.speak(text);
      await setSpeechRate(rate);
      await setPitch(pitch);
      if(pitch != null  && rate != null ){
        setPitch(pitch);
        setSpeechRate(0.5);
        await _flutterTts.setLanguage(languageCode);
        await _flutterTts.speak(text);
      }else if(pitch != null && rate != null){
        String url =
            'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q='
            '${Uri.encodeComponent(text)}&tl=$languageCode';
        setPitch(pitch);
        setSpeechRate(rate);
        await _audioPlayer.play(UrlSource(url));
        await _flutterTts.speak(text);
      }

    } else {
      // Use Google Translate TTS API for unsupported languages
      List<String> textChunks = _splitTextIntoChunks(text, 200);
      for (String chunk in textChunks) {
        await playAudio(chunk, languageCode, rate, pitch);
        await Future.delayed(Duration(seconds: 2));
        // Fluttertoast.showToast(
        //   msg: 'Playback rate adjusted to $rate',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
      }
    }
    /// </>
  }

  // Future<void> playAudio(String text, String languageCode, double rate, double pitch) async {
  //
  //   String url =
  //       'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q='
  //       '${Uri.encodeComponent(text)}&tl=$languageCode';
  //
  //   try {
  //
  //     await _audioPlayer.stop();
  //     await _audioPlayer.setPlaybackRate(rate);
  //     // print('Playback Rate: ${rate ?? 1.0}');
  //     await _audioPlayer.play(UrlSource(url));
  //
  //     if (rate != null && rate != 1.0) {
  //       Fluttertoast.showToast(
  //         msg: 'Playback rate adjusted to $rate',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: 'Failed to play audio: $e',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //     );
  //   }
  // }
  Future<void> playAudio(String text, String languageCode, double rate, double pitch) async {
    // Prepare the TTS URL
    String url =
        'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q='
        '${Uri.encodeComponent(text)}&tl=$languageCode';

    try {
      // Stop any ongoing audio playback
      await _audioPlayer.stop();

      // Set Playback Rate
      await _audioPlayer.setPlaybackRate(rate);

      // Set Pitch for Flutter TTS - this is important to do before speaking
      await _flutterTts.setPitch(pitch); // Setting pitch here
      await _flutterTts.setSpeechRate(rate);

      // Inform the user about the playback rate
      if (rate != null && rate != 0.5 || pitch != null && pitch != 0.5) {
        // Fluttertoast.showToast(
          // msg: 'Playback rate adjusted to $rate',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
      }

      // Play the audio using the available TTS URL
      await _audioPlayer.play(UrlSource(url));

    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to plfdsghlay audio: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  List<String> _splitTextIntoChunks(String text, int maxLength) {
    List<String> chunks = [];
    for (int i = 0; i < text.length; i += maxLength) {
      int end = (i + maxLength < text.length) ? i + maxLength : text.length;
      chunks.add(text.substring(i, end));
    }
    return chunks;
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      await _flutterTts.stop();
    } catch (e) {
      print('Failed to stop audio: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      print('Failed to dispose audio player: $e');
    }
  }
}
