import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _image;
  Uint8List? _processedImageBytes;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();

      setState(() {
        _image = File(image.path);
      });

      // 读取图像并旋转
      final originalImage = img.decodeImage(await _image!.readAsBytes());
      final fixedImage = img.copyRotate(originalImage!, angle: 90); // 旋转90度

      // 缩放图像以匹配预览框的大小
      final resizedImage = img.copyResize(fixedImage, width: 400, height: 400); // 调整大小为预览框的大小

      // 将调整后的图像写入文件
      final resizedImageFile = await _image!.writeAsBytes(img.encodeJpg(resizedImage));

      setState(() {
        _image = resizedImageFile;
      });

      _uploadImage();
    } catch (e) {
      print(e);
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

      // 显示结果对话框
      _showResultDialog();
    } else {
      setState(() {
        _processedImageBytes = null;
      });
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('OCR 翻譯結果'),
          content: SingleChildScrollView(
            child: _processedImageBytes != null
                ? Image.memory(_processedImageBytes!)
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR 翻譯 Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: Container(
                          // width: 400,
                          // height: 400,
                          child: ClipRect(
                            child: OverflowBox(
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.contain, // 調整圖片比例
                                child: Container(
                                  width: 350,
                                  height: 350,
                                  child: CameraPreview(_controller!),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Center(
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(50), // 圆角半径为20
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            child: Text('拍攝圖片'),
          ),
        ],
      ),
    );
  }
}

