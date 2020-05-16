import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_caixa.dart';
import 'package:praiabarraca/componentes/item_menu.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';
import 'package:praiabarraca/modelos/usuario.dart';
import 'package:praiabarraca/utilitarios/import_menus.dart';

class TelaMenu extends StatefulWidget {
  final String idUsuario;
  final String idEstabelecimento;

  TelaMenu({@required this.idUsuario, @required this.idEstabelecimento});

  @override
  _TelaMenuState createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  Usuario usuario;
  Estabelecimento estabelecimento;

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('estabelecimentos')
        .document(widget.idEstabelecimento)
        .get()
        .then((doc) {
      setState(() {
        this.estabelecimento = new Estabelecimento(
          id: widget.idEstabelecimento,
          nome: doc['nome'] as String,
          local: doc['local'] as String,
          dono: doc['dono'] as String,
          idCaixaAtual: doc['idCaixaAtual'],
          isCaixaAberto: doc['isCaixaAberto'] as bool,
          saldoAnterior: double.tryParse(doc['saldoAnterior']),
        );
      });
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(
              estabelecimento == null ? 'Carregando...' : estabelecimento.nome),
        ),
        body: estabelecimento == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ' Gerenciamentos',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ItemMenu(
                      icone: Icon(
                        Icons.monetization_on,
                        color: estabelecimento.isCaixaAberto
                            ? Colors.green
                            : Colors.red,
                      ),
                      titulo: estabelecimento.isCaixaAberto
                          ? 'Fechar Caixa'
                          : 'Abrir Caixa',
                      onTap: () {
                        if (estabelecimento.isCaixaAberto) {
                          Firestore.instance
                              .collection('caixas')
                              .document(estabelecimento.idCaixaAtual)
                              .collection('comandas')
                              .where('isAberto', isEqualTo: true)
                              .getDocuments()
                              .then((docs) {
                            if (docs.documents.length == 0) {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) {
                                    return FormCaixa(estabelecimento);
                                  });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text("Fechamento de Caixa"),
                                    content: new Text(
                                        "Para realizar o fechamento do caixa, todas as comandas devem ser fechadas."),
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
                          });
                        } else {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (_) {
                                return FormCaixa(estabelecimento);
                              });
                        }
                      },
                    ),
                    ItemMenu(
                      icone: Icon(Icons.launch),
                      titulo: 'Movimentos',
                      onTap: () {
                        if (!estabelecimento.isCaixaAberto) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Movimentação indisponivel"),
                                content: new Text(
                                    "Para utilizar a movimentação, é necessário realizar a abertura de caixa."),
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
                        if (1 == 1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Movimentação indisponivel"),
                                content: new Text(
                                    "Esta função ainda esta em desenvolvimento."),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                TelaProdutos(widget.idEstabelecimento),
                          ),
                        );
                      },
                    ),
                    ItemMenu(
                      icone: Icon(Icons.format_list_numbered),
                      titulo: 'Comandas',
                      onTap: () {
                        if (!estabelecimento.isCaixaAberto) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text(
                                    "Gerenciamento de comandas indisponivel"),
                                content: new Text(
                                    "Para utilizar o gerenciamento de comandas, é necessário realizar a abertura de caixa."),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TelaComandas(estabelecimento),
                          ),
                        );
                      },
                    ),
                    ItemMenu(
                      icone: Icon(Icons.content_paste),
                      titulo: 'Produtos',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                TelaProdutos(widget.idEstabelecimento),
                          ),
                        );
                      },
                    ),
                    ItemMenu(
                      icone: Icon(Icons.person),
                      titulo: 'Colaboradores',
                      onTap: () {
                        if (1 == 1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text(
                                    "Gerenciamento de colaboradores indisponivel"),
                                content: new Text(
                                    "Esta função ainda esta em desenvolvimento."),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TelaColaboradores(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50),
                    Text(
                      ' Registros',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ItemMenu(
                      icone: Icon(Icons.print),
                      titulo: 'Histórico do Caixa',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                TelaHistoricoCaixa(widget.idEstabelecimento),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )));
  }
}
