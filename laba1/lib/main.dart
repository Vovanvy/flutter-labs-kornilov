import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Лабораторная работа 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 112,
          title: const Text(
            'Корнилов Вова\nПдо-36',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: const Center(child: Text('Hello World!')),
      ),
    );
  }
}
