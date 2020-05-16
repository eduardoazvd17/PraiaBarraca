import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praiabarraca/componentes/lista_detalhes_comandas.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'package:praiabarraca/modelos/caixa.dart';

class TelaDetalhesCaixa extends StatefulWidget {
  final Caixa caixa;

  TelaDetalhesCaixa(this.caixa);

  @override
  _TelaDetalhesCaixaState createState() => _TelaDetalhesCaixaState();
}

class _TelaDetalhesCaixaState extends State<TelaDetalhesCaixa> {
  QuerySnapshot snapshots;
  String idComandaSelecionada;
  int quantidadePedidos = 0;

  _alterarQuantidadePedidos(int valor) {
    setState(() {
      quantidadePedidos = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('caixas')
        .document(widget.caixa.id)
        .collection('comandas')
        .getDocuments()
        .then((docs) {
      setState(() {
        snapshots = docs;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Caixa'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              ' Caixa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Abertura: ${DateFormat('dd/MM/yyyy - H:mm').format(widget.caixa.abertura)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Fechamento: ${DateFormat('dd/MM/yyyy - H:mm').format(widget.caixa.fechamento)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ganhos: R\$${widget.caixa.saldo.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Retirada: R\$${widget.caixa.valorRetirada.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  ' Comandas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                snapshots == null
                    ? Container()
                    : snapshots.documents.length == 0
                        ? Container()
                        : Text('${snapshots.documents.length} '),
              ],
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  child: snapshots == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : snapshots.documents.length == 0
                          ? MensagemListaVazia('Nenhuma comanda registrada')
                          : ListView.builder(
                              itemCount: snapshots.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc =
                                    snapshots.documents[index];
                                return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: CircleAvatar(
                                              child: FittedBox(
                                            child: Text(doc.documentID),
                                          )),
                                          title: Text(
                                            '${doc['nomeCliente']}',
                                            overflow: TextOverflow.fade,
                                          ),
                                          subtitle: Text(
                                            '${doc['telefoneCliente']}',
                                            overflow: TextOverflow.fade,
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                  'Subtotal: R\$${double.tryParse(doc['total']).toStringAsFixed(2)}'),
                                              Text(
                                                  'Desconto: R\$${double.tryParse(doc['desconto']).toStringAsFixed(2)}'),
                                              Text(
                                                  'Total: R\$${(double.tryParse(doc['total']) - double.tryParse(doc['desconto'])).toStringAsFixed(2)}'),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              idComandaSelecionada =
                                                  doc.documentID;
                                            });
                                          },
                                        ),
                                        Divider(),
                                      ],
                                    ));
                              },
                            ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  idComandaSelecionada == null
                      ? ' Pedidos'
                      : ' Pedidos da Comanda $idComandaSelecionada',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                quantidadePedidos == 0
                    ? Container()
                    : Text('$quantidadePedidos '),
              ],
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  child: idComandaSelecionada == null
                      ? MensagemListaVazia(
                          'Selecione uma comanda para exibir seus pedidos')
                      : ListaDetalhesComandas(widget.caixa,
                          idComandaSelecionada, _alterarQuantidadePedidos),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
