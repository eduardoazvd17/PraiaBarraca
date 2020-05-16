import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaCadastro extends StatelessWidget {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmacaoSenhaController = TextEditingController();

  _cadastrar(context) async {
    String nome = nomeController.text;
    String email = emailController.text;
    String senha = senhaController.text;
    String confirmacaoSenha = confirmacaoSenhaController.text;

    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        confirmacaoSenha.isEmpty) {
      return;
    }

    if (senha.length < 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Senha muito fraca"),
            content: new Text("Sua senha deve conter 6 ou mais caracteres."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (!(senha == confirmacaoSenha)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Senhas diferentes"),
            content:
                new Text("A senha e a confirmação de senha devem ser iguais."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(height: 15),
                new Text(
                  "Carregando",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      AuthResult auth =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      FirebaseUser usuario = auth.user;
      UserUpdateInfo update = new UserUpdateInfo();
      update.displayName = nome;
      usuario.updateProfile(update);
      Firestore.instance.collection('usuarios').document(usuario.uid).setData({
        'nome': nome,
        'email': email,
        'isAtivo': false,
        'maximoEstabelecimentos': 1,
      });
      usuario.sendEmailVerification();
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Cadastro efetuado"),
            content: new Text(
                "Enviamos um e-mail de verificação para: $email, para ativar sua conta basta clicar no link enviado. Será necessário verificar antes de entrar."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.of(context).pop();
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("E-mail inválido"),
                  content: new Text("Digite um endereço de e-mail válido."),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("E-mail existente"),
                  content: new Text(
                      "Já existe uma conta associada a este endereço de e-mail."),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
          break;
        default:
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Credenciais incorretas"),
                  content: new Text(
                      "E-mail ou senha incorretos. Verifique a digitação e tente novamente."),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var altura = MediaQuery.of(context).size.height;
    var largura = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: altura * 0.25,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(largura * 0.1, altura * 0.05,
                      largura * 0.1, altura * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        maxLines: 1,
                        obscureText: false,
                        controller: nomeController,
                        autofocus: false,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.fromLTRB(largura * 0.05,
                                altura * 0.015, largura * 0.05, altura * 0.015),
                            hintText: "Nome Completo",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: altura * 0.01),
                      TextField(
                        maxLines: 1,
                        obscureText: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.fromLTRB(largura * 0.05,
                                altura * 0.015, largura * 0.05, altura * 0.015),
                            hintText: "E-mail",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: altura * 0.01),
                      TextField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        controller: senhaController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.vpn_key),
                            contentPadding: EdgeInsets.fromLTRB(largura * 0.05,
                                altura * 0.015, largura * 0.05, altura * 0.015),
                            hintText: "Senha",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: altura * 0.01),
                      TextField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        controller: confirmacaoSenhaController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.vpn_key),
                            contentPadding: EdgeInsets.fromLTRB(largura * 0.05,
                                altura * 0.015, largura * 0.05, altura * 0.015),
                            hintText: "Confirmação de Senha",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: altura * 0.01),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.orange,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(largura * 0.05,
                              altura * 0.015, largura * 0.05, altura * 0.015),
                          onPressed: () => _cadastrar(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Cadastrar-se",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: largura * 0.02),
                              Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: altura * 0.01),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(largura * 0.05,
                              altura * 0.015, largura * 0.05, altura * 0.015),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Cancelar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: largura * 0.02),
                              Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
