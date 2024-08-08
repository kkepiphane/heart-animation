import 'package:animeheart/themes/cercle_custom_pain.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int ratings = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black12,
        body: Stack(
          children: [
            // Positionner CircleCustomPain pour occuper tout l'espace
            Positioned.fill(
              child: CircleCustomPain(
                durationInSeconds:
                    100 - ratings, // Convertir en int si nécessaire
              ),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Slider(
                  value: ratings
                      .toDouble(), // Convertir int en double pour le Slider
                  onChanged: (newRating) {
                    setState(() =>
                        ratings = newRating.toInt()); // Convertir double en int
                  },
                  min: 1,
                  max: 99,
                  divisions: 99, // Optionnel : pour avoir des valeurs entières
                  label: "$ratings",
                  thumbColor: Colors.blue[600],
                  activeColor: Colors.blue[400]),
            ),
          ],
        ),
      ),
    );
  }
}
