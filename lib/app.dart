import 'package:flutter/material.dart';
import 'package:stegaimage/introduction/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}
