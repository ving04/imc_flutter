import 'package:flutter/material.dart';
import 'package:imc_flutter/pages/calculo_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return const DadosImc();
  }
}