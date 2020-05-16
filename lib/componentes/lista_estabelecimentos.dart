import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'package:praiabarraca/telas/tela_menu.dart';

import 'form_estabelecimento.dart';

class ListaEstabelecimentos extends StatelessWidget {
  final String idUsuario;
  ListaEstabelecimentos(this.idUsuario);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('estabelecimentos')
            .where('dono', isEqualTo: idUsuario)
            .getDocuments()
            .asStream(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshots.data.documents.length == 0) {
            return MensagemListaVazia('Nenhum estabelecimento cadastrado');
          }
          return ListView.builder(
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshots.data.documents[index];
              bool isCaixaAberto = doc['isCaixaAberto'] as bool;
              return Card(
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCaixaAberto ? Colors.green : Colors.red,
                    child: Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  title: Text(
                    '${doc['nome']}',
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    '${doc['local']}',
                    overflow: TextOverflow.fade,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.indigo,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (_) {
                                  return FormEstabelecimento(
                                    idUsuario: idUsuario,
                                    idEstabelecimento: doc.documentID,
                                    nome: doc['nome'],
                                    local: doc['local'],
                                  );
                                });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Excluir Estabelecimento"),
                                  content: new Text(
                                      "Deseja realmente excluir o estabelecimento: ${doc['nome']}?, Todos os produtos cadastrados e registros de caixas também serão apagados."),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("Sim"),
                                      onPressed: () {
                                        Firestore.instance
                                            .collection('estabelecimentos')
                                            .document(doc.documentID)
                                            .collection('produtos')
                                            .getDocuments()
                                            .then((docs) {
                                          for (var doc in docs.documents) {
                                            doc.reference.delete();
                                          }
                                          Firestore.instance
                                              .collection('caixas')
                                              .where('estabelecimento',
                                                  isEqualTo: doc.documentID)
                                              .getDocuments()
                                              .then((docs) {
                                            for (var doc in docs.documents) {
                                              doc.reference
                                                  .collection('comandas')
                                                  .getDocuments()
                                                  .then((docs) {
                                                for (var doc
                                                    in docs.documents) {
                                                  doc.reference
                                                      .collection('pedidos')
                                                      .getDocuments()
                                                      .then((docs) {
                                                    for (var doc
                                                        in docs.documents) {
                                                      doc.reference.delete();
                                                    }
                                                  });
                                                  doc.reference.delete();
                                                }
                                              });
                                              doc.reference.delete();
                                            }
                                          });
                                          doc.reference.delete();
                                        });
                                        Navigator.of(context).pop();
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
                          }),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TelaMenu(
                          idUsuario: idUsuario,
                          idEstabelecimento: doc.documentID,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
