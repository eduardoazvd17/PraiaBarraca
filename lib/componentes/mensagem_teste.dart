import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/telas/tela_login.dart';

class MensagemTeste extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                      'Esta é uma versão de testes do app Praia Barraca, sua conta precisa ser ativada por um administrador. Para ativar seu período de testes entre em contato com o desenvolvedor Eduardo pelo whatsapp: (21) 98854-2950, e informe seu e-mail cadastrado.'),
                  SizedBox(height: 20),
                  FlatButton(
                    child: Text(
                      'Finalizar Sessão',
                      style: TextStyle(color: Colors.indigo),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Finalizar Sessão"),
                            content: new Text("Deseja realmente sair?"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Sim"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => TelaLogin(),
                                    ),
                                  );
                                },
                              ),
                              new FlatButton(
                                child: new Text("Não"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
