import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'form_produto.dart';

class ListaProdutos extends StatelessWidget {
  final String idEstabelecimento;
  ListaProdutos(this.idEstabelecimento);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('estabelecimentos')
            .document(idEstabelecimento)
            .collection('produtos')
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshots.data.documents.length == 0) {
            return MensagemListaVazia('Nenhum produto cadastrado');
          }
          return ListView.builder(
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshots.data.documents[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(
                    '${doc['nome']}',
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    'R\$${double.tryParse(doc['valor']).toStringAsFixed(2)}',
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
                                  return FormProduto(
                                    idEstabelecimento: idEstabelecimento,
                                    idProduto: doc.documentID,
                                    nome: doc['nome'],
                                    valor: double.tryParse(doc['valor']),
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
                                  title: new Text("Excluir Produto"),
                                  content: new Text(
                                      "Deseja realmente excluir o produto: ${doc['nome']}?"),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("Sim"),
                                      onPressed: () {
                                        doc.reference.delete();
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
