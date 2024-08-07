import 'package:animeheart/themes/cercle_custom_pain.dart';
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
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: CircleCustomPain(
            durationInSeconds: 120,
          ),
        ),
      ),
    );
  }
}
