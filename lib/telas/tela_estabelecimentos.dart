import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_estabelecimento.dart';
import 'package:praiabarraca/componentes/lista_estabelecimentos.dart';
import 'package:praiabarraca/componentes/mensagem_teste.dart';
import 'package:praiabarraca/modelos/usuario.dart';
import 'package:praiabarraca/telas/tela_login.dart';

class TelaEstabelecimentos extends StatefulWidget {
  final String idUsuario;
  TelaEstabelecimentos(this.idUsuario);

  @override
  _TelaEstabelecimentosState createState() => _TelaEstabelecimentosState();
}

class _TelaEstabelecimentosState extends State<TelaEstabelecimentos> {
  Usuario usuario;
  int totalEstabelecimentos;

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('usuarios')
        .document(widget.idUsuario)
        .get()
        .then((doc) {
      setState(() {
        this.usuario = new Usuario(
          id: widget.idUsuario,
          nome: doc['nome'] as String,
          email: doc['email'] as String,
          isAtivo: doc['isAtivo'] as bool,
          maximoEstabelecimentos: doc['maximoEstabelecimentos'] as int,
        );
      });
    });

    Firestore.instance
        .collection('estabelecimentos')
        .where('dono', isEqualTo: widget.idUsuario)
        .getDocuments()
        .then((docs) {
      setState(() {
        totalEstabelecimentos = docs.documents.length;
      });
    });

    _modalAdicionarEstabelecimento(context) {
      if (usuario.maximoEstabelecimentos <= totalEstabelecimentos) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Conta Limitada"),
              content: new Text(
                  "Para fins de segurança limitamos novas contas para a adição de apenas 1 estabelecimento para testes."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Ok"),
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
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
            return FormEstabelecimento(
              idUsuario: usuario.id,
            );
          });
    }

    return usuario == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : usuario.isAtivo
            ? Scaffold(
                appBar: AppBar(
                  title: Text('Meus Estabelecimentos'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _modalAdicionarEstabelecimento(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
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
                                            builder: (_) => TelaLogin()));
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
                body: ListaEstabelecimentos(widget.idUsuario),
                floatingActionButton: FloatingActionButton(
                  tooltip: 'Adicionar Estabelecimento',
                  child: Icon(Icons.add),
                  onPressed: () => _modalAdicionarEstabelecimento(context),
                ),
              )
            : MensagemTeste();
  }
}
