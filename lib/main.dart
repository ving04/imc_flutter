import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:imc_flutter/pages/home.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var documentsDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);

  var box = await Hive.openBox('imc_box');

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