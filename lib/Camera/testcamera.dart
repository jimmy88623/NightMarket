import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class TestCamera extends StatefulWidget {
  const TestCamera({super.key});

  @override
  State<TestCamera> createState() => _TestCameraState();
}

class _TestCameraState extends State<TestCamera> {
  File? _selectedImage;
  Uint8List? _processedImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C81A0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text('看板を写真に撮って、認識してみませんか?',style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),)),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width*1.2,
            color: Colors.white,
            child: _selectedImage != null
                ? Container(
              child: Image.file(_selectedImage!,fit: BoxFit.cover,),
              color: Colors.black,
              width: double.infinity,
            )
                : const Text(''),
          ),
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF666666)
                ),
                child: IconButton(
                    icon: Icon(Icons.collections, color: Colors.white,size:50,),
                    onPressed: () {
                      _pickImageFromGallery();
                    }),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF666666)
                ),
                child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white,size:50,),
                    onPressed: () {
                      _pickImageFromCamera();
                    }),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF666666)
                ),
                child: IconButton(
                    icon: Icon(Icons.translate, color: Colors.white,size:50,),
                    onPressed: () {
                      _uploadImage();
                    }),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF666666)
                ),
                child: IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white,size:50,),
                    onPressed: () {
                      _clearImage();
                    }),
              ),
            ],
          ),

          // const SizedBox(
          //   height: 20,
          // ),
        ],
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future _uploadImage() async {
    if (_selectedImage == null) return;

    final request = http.MultipartRequest('POST', Uri.parse('http://192.168.50.110:5001/process_image'));
    request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();
      setState(() {
        _processedImage = bytes;
      });
      _showResultDialog();
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }


  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('OCR 翻譯結果'),
          content: SingleChildScrollView(
            child: _processedImage != null
                ? Image.memory(_processedImage!)
                : Text('無法顯示翻譯結果'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('關閉'),
            ),
          ],
        );
      },
    );
  }

}