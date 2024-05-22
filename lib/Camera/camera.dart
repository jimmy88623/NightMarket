import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OcrScreen(),
    );
  }
}

class OcrScreen extends StatefulWidget {
  @override
  _OcrScreenState createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  File? _image;
  Uint8List? _processedImageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5000/process_image'));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();
      setState(() {
        _processedImageBytes = bytes;
      });
    } else {
      setState(() {
        _processedImageBytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR 翻译 Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('拍摄图片'),
            ),
            SizedBox(height: 20),
            _processedImageBytes != null
                ? Image.memory(_processedImageBytes!)
                : Text(
              '拍摄或上传图片并等待翻译结果',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

