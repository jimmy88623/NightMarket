import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class SpeechRecognitionPage extends StatefulWidget {
  const SpeechRecognitionPage({Key? key}) : super(key: key);




  @override
  State<SpeechRecognitionPage> createState() => _SpeechRecognitionPageState();
}

class _SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'ボタンを押して話し始めてください';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async{
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) =>
              setState(() {
                _text = val.recognizedWords;
              }),
              localeId: 'ja_JP',      //設置語言為日文
        );
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    }else{
      setState(() => _isListening = false);
      Navigator.pop(context,"香腸");
      _speech.stop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "語音辨識",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _text,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening? Icons.mic :Icons.mic_none),
      ),
    );
  }
}
              //     DropdownButton(
              //       value: selectedLanguage,
              //       icon: Icon(Icons.keyboard_arrow_down),
              //       onChanged: (String? value) {
              //         setState(() {
              //           selectedLanguage = value!;
              //         });
              //       },
              //       items: items.map((String item) {
              //         return DropdownMenuItem(
              //           value: item,
              //           child: Text(item),
              //         );
              //       }).toList(),
              //     ),
              //   ],
              // ),
//             )
//           ],
//         ));
//   }
// }
//
