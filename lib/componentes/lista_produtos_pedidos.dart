import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_pedidos.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';
import 'package:praiabarraca/modelos/produto.dart';

class ListaProdutosPedidos extends StatelessWidget {
  final Estabelecimento estabelecimento;
  final String idComanda;
  ListaProdutosPedidos(this.estabelecimento, this.idComanda);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('caixas')
            .document(estabelecimento.idCaixaAtual)
            .collection('comandas')
            .document(idComanda)
            .collection('pedidos')
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshots.data.documents.length == 0) {
            return MensagemListaVazia('Nenhum pedido realizado');
          }
          return ListView.builder(
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshots.data.documents[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    child: FittedBox(
                      child: Text(
                        '${doc['quantidade']}x',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.indigo,
                  ),
                  title: Text(
                    '${doc['pedido']}',
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    'R\$${(double.tryParse(doc['valor']) * doc['quantidade']).toStringAsFixed(2)}',
                    overflow: TextOverflow.fade,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.indigo,
                        onPressed: () {
                          Produto produto = new Produto(
                            doc.documentID,
                            doc['pedido'],
                            double.tryParse(doc['valor']),
                          );
                          //Abre o modal que adiciona/edita o pedido deixando alterar a quantidade desse pedido.
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (_) {
                                return FormPedido(
                                  estabelecimento: estabelecimento,
                                  idComanda: idComanda,
                                  produto: produto,
                                  quantidade: doc['quantidade'] as int,
                                );
                              });
                        },
                      ),
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
                                  title: new Text("Excluir Pedido"),
                                  content: new Text(
                                      "Deseja realmente excluir o pedido: ${doc['pedido']}?"),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("Sim"),
                                      onPressed: () {
                                        doc.reference.delete();
                                        Firestore.instance
                                            .collection('caixas')
                                            .document(
                                                estabelecimento.idCaixaAtual)
                                            .collection('comandas')
                                            .getDocuments()
                                            .then((comandasDoc) {
                                          for (var c in comandasDoc.documents) {
                                            c.reference
                                                .collection('pedidos')
                                                .getDocuments()
                                                .then((produtosDoc) {
                                              double total = 0;
                                              for (var p
                                                  in produtosDoc.documents) {
                                                total = (p['quantidade']
                                                        as int) *
                                                    double.tryParse(p['valor']);
                                              }
                                              c.reference.updateData({
                                                'total':
                                                    total.toStringAsFixed(2)
                                              });
                                            });
                                          }
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
