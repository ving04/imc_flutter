import 'package:flutter/material.dart';
import 'package:imc_flutter/pages/home.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, 
      ),
      home: Home(),
    );
  }
}