import 'package:chatgptapi/api/api.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List ask = [];
  List response = [];
  bool isLoading = false;
  TextEditingController control = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  //   child: ElevatedButton(
                  //       onPressed: () async {
                  //         var resp = await say();
                  //         setState(() {
                  //           response = resp;
                  //         });
                  //       },
                  //       child: const Text('Chamar APi get')),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: TextFormField(
                      enabled: !isLoading,
                      controller: control,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.question_answer),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2)),
                          isDense: true,
                          label: Text('Digite aqui sua pergunta')),
                    ),
                  ),
                  !isLoading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onPressed: () async {
                                if (control.text == '') {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text('Alerta!'),
                                          content: const Text(
                                              'O campo não pode ficar em branco!'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Voltar'))
                                          ],
                                        );
                                      });
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var resp = await saypost(control.text);

                                  setState(() {
                                    showDialog<bool>(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            title: Text(control.text),
                                            content: Text(resp!),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    control.text = '';
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Voltar'))
                                            ],
                                          );
                                        });
                                    ask.add(control.text);
                                    response.add(resp);
                                    isLoading = false;
                                  });
                                }
                              },
                              child: const Text('Pergunte-me')),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 30),
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () {},
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                  response == null
                      ? const Center(child: Text('Sem respostas ainda!'))
                      : SizedBox(
                          height: 300,
                          child: ListView.builder(
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: response.length,
                              itemBuilder: (BuildContext context, index) {
                                return ExpansionTile(
                                  initiallyExpanded: true,
                                  childrenPadding:
                                      const EdgeInsets.only(bottom: 15),
                                  leading: const Icon(Icons.question_answer),
                                  title: Text('Pergunta ${index + 1}'),
                                  subtitle: Text(ask[index]),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(response[index] ?? 'Nada'),
                                    )
                                  ],
                                );
                              }),
                        )
                ],
              ),
            ),
          ),
          Positioned(
              top: 40,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      response.clear();
                      ask.clear();
                    });
                  },
                  icon: const Icon(Icons.cleaning_services_rounded)))
        ],
      ),
    );
  }
}
