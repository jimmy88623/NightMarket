import 'package:flutter/material.dart';
import 'package:nightmarket/ButtonBar/buttonbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: const Scaffold(
        // appBar: AppBar(
        //   title: const Text('Ya市'),
        //   centerTitle: true ,
        //   elevation: 2,
        // ),
        body: ButtonbarPage(),
      ),
    );
  }
}