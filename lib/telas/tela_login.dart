import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_redefinir_senha.dart';
import 'package:praiabarraca/telas/tela_cadastro.dart';
import 'package:praiabarraca/telas/tela_estabelecimentos.dart';

class TelaLogin extends StatelessWidget {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  _entrar(context) async {
    String email = emailController.text;
    String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
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
      AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      FirebaseUser usuario = auth.user;
      if (!usuario.isEmailVerified) {
        usuario.sendEmailVerification();
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Verificação de e-mail pendente"),
              content: new Text(
                  "Seu e-mail ainda não foi verificado, reenviamos um e-mail para: $email, para ativar sua conta basta clicar no link enviado."),
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
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TelaEstabelecimentos(auth.user.uid),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
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

  _modalRedefinirSenha(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return FormRedefinirSenha(emailController.text);
        });
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: altura * 0.25,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: largura * 0.1, vertical: altura * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.orange,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(largura * 0.05,
                              altura * 0.015, largura * 0.05, altura * 0.015),
                          onPressed: () => _entrar(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Entrar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: largura * 0.02),
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Criar minha conta'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TelaCadastro(),
                          ),
                        );
                      },
                    ),
                    FlatButton(
                      child: Text('Esqueci minha senha'),
                      onPressed: () => _modalRedefinirSenha(context),
                    ),
                  ],
                ),
                FlatButton(
                  child: Text('Política de privacidade'),
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
