import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:nightmarket/ButtonBar/buttonbar.dart';
import 'package:nightmarket/Food%20Illustration/like_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://140.116.245.153:8087/login'),
      body: {
        'account': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody)),
      );
      if (responseBody == "登入成功") {
        // Provider.of<LikeProvider>(context,listen: false).clearLikedItems();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ButtonbarPage()), // 跳转到主页
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 当点击空白处时，收起键盘
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/login.png',
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.width * 0.2),
                    TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0
                      ),
                      controller: _emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0x80D9D9D9),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Enter Email Here',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                    TextField(
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0
                      ),
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0x80D9D9D9),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Enter Password Here',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                    OutlinedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color(0x80D9D9D9),
                        minimumSize: Size(MediaQuery.of(context).size.width * 0.4,
                            MediaQuery.of(context).size.width * 0.13),
                      ),
                      child: const Text(
                        'login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToSignup,
                      child: const Text(
                        'Don\'t have an account? Signup',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: ClipOval(
                              child: Image.asset('assets/google.png',
                                  height: 50, width: 50),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: ClipOval(
                              child: Image.asset('assets/line.png',
                                  height: 50, width: 50),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: ClipOval(
                              child: Image.asset('assets/fb.png',
                                  height: 50, width: 50),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: Image.asset(
                'assets/夜市小吃.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup() async {
    final response = await http.post(
      Uri.parse('http://140.116.245.153:8087/sign'),
      body: {
        'username': _fullNameController.text,
        'account': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful: $responseBody')),
      );
      Navigator.pop(context); // 注册成功后返回登录页面
    } else {
      final responseBody = response.body; // 获取错误信息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${response.reasonPhrase}\n$responseBody')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/login.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0
                    ),
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x80D9D9D9),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Full Name',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                  TextField(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0
                    ),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x80D9D9D9),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                  TextField(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0
                    ),
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x80D9D9D9),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0x80D9D9D9),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.4,
                          MediaQuery.of(context).size.width * 0.13),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
