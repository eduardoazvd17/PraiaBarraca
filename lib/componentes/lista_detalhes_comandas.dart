import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'package:praiabarraca/modelos/caixa.dart';

class ListaDetalhesComandas extends StatefulWidget {
  final Caixa caixa;
  final String idComanda;
  final Function(int) alterarQuantidadePedidos;
  ListaDetalhesComandas(
      this.caixa, this.idComanda, this.alterarQuantidadePedidos);

  @override
  _ListaDetalhesComandasState createState() => _ListaDetalhesComandasState();
}

class _ListaDetalhesComandasState extends State<ListaDetalhesComandas> {
  QuerySnapshot snapshots;

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('caixas')
        .document(widget.caixa.id)
        .collection('comandas')
        .document(widget.idComanda)
        .collection('pedidos')
        .getDocuments()
        .then((docs) {
      widget.alterarQuantidadePedidos(docs.documents.length);
      setState(() {
        snapshots = docs;
      });
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: snapshots == null
          ? Center(child: CircularProgressIndicator())
          : snapshots.documents.length == 0
              ? MensagemListaVazia('Nenhum pedido registrado')
              : ListView.builder(
                  itemCount: snapshots.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshots.documents[index];
                    return Column(
                      children: <Widget>[
                        ListTile(
                          isThreeLine: true,
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
                            'Valor unitário: R\$${double.tryParse(doc['valor']).toStringAsFixed(2)}\nSubtotal: R\$${(double.tryParse(doc['valor']) * doc['quantidade']).toStringAsFixed(2)}',
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
    );
  }
}
