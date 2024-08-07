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
  double ratings = 1; // Définir ratings comme une variable double

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Stack(
          children: [
            // Positionner CircleCustomPain pour occuper tout l'espace
            Positioned.fill(
              child: CircleCustomPain(
                durationInSeconds:
                    100 - ratings.toInt(), // Convertir en int si nécessaire
              ),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Slider(
                value: ratings,
                onChanged: (newRating) {
                  setState(() => ratings = newRating);
                },
                min: 1,
                max: 100,
                divisions: 99, // Optionnel : pour avoir des valeurs entières
                label: "$ratings",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
