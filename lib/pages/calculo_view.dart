import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:imc_flutter/model/mask_altura.dart';

class DadosImc extends StatefulWidget {
  const DadosImc({
    super.key
  });

  @override
  State < DadosImc > createState() => _DadosImcState();
}

class _DadosImcState extends State < DadosImc > {
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();

  List<Map<dynamic, dynamic>> _items = [];

  final _imcBox = Hive.box('imc_box');
  
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  calculaImc(double peso, double altura) {
    return (peso / (altura * altura));
  }

  String imcGrau(double imc) {
    if (imc < 16) {
      return "Magreza grave";
    } else if (imc >= 16 && imc < 17) {
      return "Magreza moderada";
    } else if (imc >= 17 && imc < 18.5) {
      return "Magreza leve";
    } else if (imc >= 18.5 && imc < 25) {
      return "Saudavel";
    } else if (imc >= 25 && imc < 30) {
      return "Sobrepeso";
    } else if (imc >= 30 && imc < 35) {
      return "Obesidade Grau I";
    } else if (imc >= 35 && imc < 40) {
      return "Obesidade Grau II (severa)";
    } else if (imc >= 40) {
      return "Obesidade Grau III (mórbida)";
    }
    return "";
  }

  void _refreshItems(){
    final data = _imcBox.keys.map((key){
      final item = _imcBox.get(key);
      return {key: key, "altura": item["altura"], "peso": item["peso"], "imc": item["imc"], "imc_grau": item["imc_grau"],};
    }).toList();

    setState((){
      _items = data.reversed.toList();
    });
  }

  Future<void> _createItem(Map<dynamic, dynamic> newItem) async {
    await _imcBox.add(newItem);
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora IMC"),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 55, 34, 124),
              child: const Icon(Icons.calculate_outlined),
                onPressed: () {
                  pesoController.text = "";
                  alturaController.text = "";
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(26)),
                      ),
                      builder: (context) => SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Form(
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Calcular IMC",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                          color: Color.fromARGB(255, 22, 22, 22),
                                          height: 40,
                                        ),
                                        const SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: pesoController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: "Peso",
                                              hintText: "Peso em Quilos (Ex.: 70)",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)))),
                                          ),
                                          const SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              controller: alturaController,
                                              inputFormatters: [maskFormatter],
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: "Altura",
                                                hintText: "Altura em metros (Ex.: 1.80)",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0)))),
                                            ),
                                            const SizedBox(
                                                height: 50,
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      SizedBox(
                                                        width: 140,
                                                        height: 45,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                            Colors.redAccent,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(8),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text("Cancelar")),
                                                      ),
                                                      SizedBox(
                                                        width: 140,
                                                        height: 45,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(8),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            double peso = pesoController.text.toString() == "" ? 0.0 :
                                                            double.parse(pesoController.text);
                                                            double altura = alturaController.text.toString() == "" ? 0.0 :
                                                            double.parse(alturaController.text);
                                                            if (altura == 0) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (context) =>
                                                                AlertDialog(
                                                                  title: Text("Altura inválida"),
                                                                  content: Text("Por favor insira uma altura valida."),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: Text('OK'),
                                                                      onPressed: () => Navigator.pop(context)),
                                                                  ],
                                                                ),
                                                              );
                                                            } else if (peso == 0) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (context) =>
                                                                AlertDialog(
                                                                  title:
                                                                  Text("Peso inválido"),
                                                                  content: Text("Por favor insira um peso valido."),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: Text('OK'),
                                                                      onPressed: () => Navigator.pop(context)),
                                                                  ],
                                                                ),
                                                              );
                                                            } else {
                                                              var imc = calculaImc(peso, altura);
                                                              var imc_grau = imcGrau(imc);

                                                              _createItem({
                                                                "peso": pesoController.text,
                                                                "altura": alturaController.text,
                                                                "imc": imc.toStringAsFixed(2),
                                                                "imc_grau": imc_grau
                                                              });

                                                              Navigator.pop(context);
                                                              setState(() {});
                                                              pesoController.text = "";
                                                              alturaController.text = "";
                                                            }
                                                          },
                                                          child: const Text("Calcular")),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                  ],
                                ),
                            )),
                        ),
                      ));
                },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  "Faça um cálculo apertando o\n botão a baixo",
                  textAlign: TextAlign.center,
                )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                  // itemCount: imcRepository.imcResults.length,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final currentItem = _items[index];
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Card(
                            color: Colors.deepPurple,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // "Peso: ${imcRepository.imcResults[index].peso?.toStringAsFixed(1)} Kg",
                                          "Peso: ${(currentItem['peso'])} Kg",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          // "Altura: ${imcRepository.imcResults[index].altura.toString()} m",
                                          "Altura: ${(currentItem['altura'])} m",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // "IMC: ${imcRepository.imcResults[index].imc!.toStringAsFixed(1)}",
                                          "IMC: ${(currentItem['imc'])}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                          ),
                                        ),
                                        Text(
                                          // imcRepository.imcGrau(imcRepository.imcResults[index].imc!),
                                          "${(currentItem['imc_grau'])}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            )
                          )
                        ),
                    );
                  }),
              ),
            ),
        ],
      ),
    );
  }
}