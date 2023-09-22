import 'package:flutter/material.dart';
import 'package:imc_flutter/Repository/ImcRepository.dart';
import 'package:imc_flutter/model/mask_altura.dart';

class DadosImc extends StatefulWidget {
  const DadosImc({
    super.key
  });

  @override
  State < DadosImc > createState() => _DadosImcState();
}

class _DadosImcState extends State < DadosImc > {
  var imcRepository = ImcRepository();
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();

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
                                                              var imc = imcRepository.calculaImc(peso, altura);
                                                              imcRepository.add(peso, altura, imc);
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
                  itemCount: imcRepository.imcResults.length,
                  itemBuilder: (context, index) {
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
                                          "Peso: ${imcRepository.imcResults[index].peso?.toStringAsFixed(1)} Kg",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              icon: Icon(Icons.edit_note_outlined),
                                              color:Color.fromARGB(255, 19, 226, 29),
                                              onPressed: () {
                                                pesoController.text = imcRepository.imcResults[index].peso.toString();
                                                alturaController.text = imcRepository.imcResults[index].altura.toString();
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.vertical(
                                                        top: Radius.circular(26)
                                                      ),
                                                    ),
                                                    builder: (context) => SizedBox(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(25),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                TextField(
                                                                  controller: pesoController,
                                                                  keyboardType: TextInputType.number,
                                                                  decoration:
                                                                  const InputDecoration(
                                                                    hintText: "Peso em Quilos (Ex.: 70)",
                                                                    labelText: "Peso",
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(12.0)
                                                                      )
                                                                    )
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 16,
                                                                  ),
                                                                  TextField(
                                                                    controller: alturaController,
                                                                    inputFormatters: [maskFormatter],
                                                                    keyboardType: TextInputType.number,
                                                                    decoration:
                                                                    const InputDecoration(
                                                                      hintText: "Altura em metros (Ex.: 1.80)",
                                                                      labelText: "Altura",
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(12.0)
                                                                        )
                                                                      )
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 16,
                                                                  ),
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
                                                                            double peso = pesoController.text.toString() == "" ? 0.0 : double.parse(pesoController.text);
                                                                            double altura = alturaController.text.toString() == "" ? 0.0 : double.parse(alturaController.text);
                                                                            if (altura == 0.0) {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) =>
                                                                                const AlertDialog(
                                                                                  title: Text("Altura inválida"),
                                                                                  content: Text("Por favor insira uma altura valida."),
                                                                                ),
                                                                              );
                                                                            } else if (peso == 0.0) {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) => const AlertDialog(
                                                                                  title: Text(
                                                                                    "Peso inválido"),
                                                                                  backgroundColor:Colors.redAccent,
                                                                                  content: Text("Por favor insira um peso valido."),
                                                                                ),
                                                                              );
                                                                            } else {
                                                                              imcRepository.edit(imcRepository.imcResults[index].id.toString(), peso, altura);
                                                                              pesoController.text = "";
                                                                              alturaController.text = "";
                                                                              Navigator.pop(context);
                                                                              setState(() {});
                                                                            }
                                                                          },
                                                                          child: const Text("Editar"),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                              ],
                                                            ),
                                                        ),
                                                      )));
                                              },
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              icon: Icon(Icons.delete_forever_outlined),
                                              color:Color.fromARGB(255, 255, 17, 0),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text("Deletar IMC"),
                                                      content: const Text(
                                                          "Você tem certeza que deseja deletar esse resultado?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: const Text("Não")),
                                                          TextButton(
                                                            onPressed: () {
                                                              imcRepository.remove(imcRepository.imcResults[index].id.toString());
                                                              Navigator.pop(context);
                                                              setState(() {});
                                                            },
                                                            child: const Text("Sim")
                                                          )
                                                        ],
                                                  ));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Altura: ${imcRepository.imcResults[index].altura.toString()} m",
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
                                          "IMC: ${imcRepository.imcResults[index].imc!.toStringAsFixed(1)}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                          ),
                                        ),
                                        Text(
                                          imcRepository.imcGrau(imcRepository.imcResults[index].imc!),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                              ))),
                    );
                  }),
              ),
            ),
        ],
      ),
    );
  }
}