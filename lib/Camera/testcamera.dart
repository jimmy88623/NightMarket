import 'dart:convert';
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
  List<String>? keyword;
  List<String>? keyList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C81A0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            '看板を写真に撮って、認識してみませんか?',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          )),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: _processedImage != null
                ? GestureDetector(
                    onTap: () async {
                      List<String>? result = await _take_keyword(); // await added here
                      if (result != null) {
                        keyList = result;
                        print("Keyword List: $keyList");
                      } else {
                        keyList = null; // Handle null case if necessary
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('考えられる食べ物は、'),
                            content: Container(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: keyList?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(keyList![index]),
                                    onTap: () {
                                      // 处理选中关键词的逻辑，比如关闭对话框，执行其他操作等
                                      Navigator.of(context).pop(keyList?[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Image.memory(
                      _processedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : (_selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : const Text('')),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFF666666)),
                child: IconButton(
                    icon: Icon(
                      Icons.collections,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      _pickImageFromGallery();
                    }),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFF666666)),
                child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      _pickImageFromCamera();
                    }),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFF666666)),
                child: IconButton(
                    icon: Icon(
                      Icons.translate,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      _uploadImage();
                    }),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFF666666)),
                child: IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 50,
                    ),
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
      _processedImage = null;
      _selectedImage = File(returnedImage.path);
      print("_selectedImage : $_selectedImage ");
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;

    setState(() {
      _processedImage = null;
      _selectedImage = File(returnedImage.path);
    });
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _processedImage = null;
    });
  }

  List<String> keywordList = [];

  Future<List<String>?> _take_keyword() async {
    var url = 'http://192.168.50.18:5005/take_keyword'; // 替换为你的Flask服务器地址
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // 如果请求成功
      var data = json.decode(response.body) as List;
      // print("data is $data");
      setState(() {
        keywordList = data.cast<String>();
        keyword = keywordList;
        print(keyword);
      });
      return keyword;
    } else {
      // 处理请求失败的情况
      print('请求失败: ${response.reasonPhrase}');
    }
  }

  Future _uploadImage() async {
    if (_selectedImage == null) return;

    final request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.50.18:5005/process_image'));
    request.files
        .add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();
      setState(() {
        _processedImage = bytes;
      });
      // _showResultDialog();
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }

// void _showResultDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       double dialogWidth = MediaQuery.of(context).size.width;
//       return AlertDialog(
//         title: Center(child: Text('Translated Result')),
//         content: Container(
//           width: dialogWidth,
//           height: dialogWidth*0.8,
//           child: _processedImage != null
//               ? Container(
//                   child: Image.memory(
//                     _processedImage!,
//                     fit: BoxFit.cover,
//                   ),
//                   width: double.infinity,
//                 )
//               : Text('無法顯示翻譯結果'),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // 关闭对话框
//             },
//             child: Text('關閉'),
//           ),
//         ],
//       );
//     },
//   );
// }
}
