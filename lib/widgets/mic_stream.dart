import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
class MicStreamScreen extends StatefulWidget {
  const MicStreamScreen({super.key});

  @override
  State<MicStreamScreen> createState() => _MicStreamScreenState();
}

class _MicStreamScreenState extends State<MicStreamScreen> {

 final SpeechToText _speechToText = SpeechToText();
 bool _speechEnabled = false;
 String _wordsSpoken = '';
 String _correctedSentence = '';
 List<Map<String, dynamic>> _errors = [];

 @override
 void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
   _speechEnabled = await _speechToText.initialize();
   setState(() {

   });
  }

  void _startListening() async {
   await _speechToText.listen(onResult: _onSpeechResult);
   setState(() {

   });
  }

  void _onSpeechResult(result) {
   setState(() {
     _wordsSpoken = result.recognizedWords;
   });
   _checkGrammer(_wordsSpoken);
  }
  Future<void> _checkGrammer(String text) async  {
   final String apiUrl = 'https://api.languagetool.org/v2/check';
   final Map<String, String> headers = {
     'Content-Type': 'application/x-www-form-urlencoded',
   };
   final body = {
     'text': text,
     'language':'en',
   };
   try{
     final response = await http.post(
       Uri.parse(apiUrl),
       headers: headers,
       body: body,
     );

     if(response.statusCode == 200){
       final data = json.decode(response.body);
       final  List<Map<String, dynamic>> errors = [];
       String correctedSentence = text;

       for(var match in data['matches']){
         int offset = match['context']['offset'];
         int length = match['context']['length'];
         String original = text.substring(offset, offset + length);

         if(match['replacements'].isNotEmpty){
           String suggestion = match['replacements'][0]['value'];
           errors.add({
             'start': offset,
             'end':  offset + length,
             'original': original,
             'suggestion': suggestion
           });
           correctedSentence = correctedSentence.replaceRange(
               offset, offset + length, suggestion);
         }
    }
       setState(() {
         _errors = errors;
         _correctedSentence = correctedSentence;
       });
     } else {
       print('Error: ${response.statusCode}');
     }

   } catch(e) {
     print('Error checking grammer: $e');

   }
  }

  void _stopListening() async{
   await _speechToText.stop();
   setState(() {

   });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
Card(
  color: Colors.deepPurple.shade50,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Text(
          _speechToText.isListening
              ? "Listening...."
              : _speechEnabled
              ? "Tap the microphone"
              : "speech not available",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  ),
),
            SizedBox(height: 20,),
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Original Sentence: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10,),
                  // _buildHighlightedText(),
                  SizedBox(height: 20,),
                  Text("Corrected Sentence",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10,),
                  Text(_correctedSentence,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                ],
              ),
            ))
            // Center(
            //   child: Container(
            //     height: 70,
            //     width: 300,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(25),
            //       color: Colors.orange
            //     ),
            //     child: TextButton(onPressed: (){}, child: regularText(title: 'MIC Say\'s', textColor: Colors.white, textSize: 25)),
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed:
      _speechToText.isListening ? _stopListening : _startListening,
      tooltip: 'Listen',
        backgroundColor: Colors.deepPurple,
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic,
        color: Colors.white
          ,),
      ),
    );
  }
}