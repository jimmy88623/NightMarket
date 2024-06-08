import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nightmarket/ButtonBar/buttonbar.dart';

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
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
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
                  SizedBox(height: 10),
                  TextField(
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
                  SizedBox(height: 20),
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
                      children: [
                        IconButton(
                          onPressed: (){},
                          icon:Image.asset('assets/google.png',height: 50,width: 50,)
                        ),
                        IconButton(
                            onPressed: (){},
                            icon:Image.asset('assets/line.png',height: 50,width: 50,)
                        ),
                        IconButton(
                            onPressed: (){},
                            icon:Image.asset('assets/fb.png',height: 50,width: 50,)
                        )
                      ],
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
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
