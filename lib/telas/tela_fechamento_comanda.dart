import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_desconto.dart';
import 'package:praiabarraca/componentes/item_menu.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'package:praiabarraca/modelos/comanda.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';

class TelaFechamentoComanda extends StatefulWidget {
  final Estabelecimento estabelecimento;
  final Comanda comanda;

  TelaFechamentoComanda(this.estabelecimento, this.comanda);

  @override
  _TelaFechamentoComandaState createState() => _TelaFechamentoComandaState();
}

class _TelaFechamentoComandaState extends State<TelaFechamentoComanda> {
  QuerySnapshot snapshots;
  double totalComanda = 0.00;
  double desconto = 0.00;

  _alterarDesconto(valor) {
    setState(() {
      desconto = valor;
    });
  }

  _abrirModalDesconto(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return FormDesconto(
            estabelecimento: widget.estabelecimento,
            comanda: widget.comanda,
            total: totalComanda,
            desconto: desconto,
            alterarDesconto: _alterarDesconto,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('caixas')
        .document(widget.estabelecimento.idCaixaAtual)
        .collection('comandas')
        .document(widget.comanda.id.toString())
        .collection('pedidos')
        .getDocuments()
        .then((docs) {
      double total = 0.00;
      for (var doc in docs.documents) {
        total += double.tryParse(doc['valor']) * doc['quantidade'];
      }
      setState(() {
        snapshots = docs;
        totalComanda = total;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Registros da comanda ${widget.comanda.id}'),
      ),
      body: snapshots == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ' Cliente',
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
                                'Comanda: ${widget.comanda.id}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Nome: ${widget.comanda.nomeCliente}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Celular: ${widget.comanda.telefoneCliente}',
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
                        ' Pedidos',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                ? MensagemListaVazia('Nenhum pedido realizado')
                                : ListView.builder(
                                    itemCount: snapshots.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot doc =
                                          snapshots.documents[index];
                                      return Column(
                                        children: <Widget>[
                                          ListTile(
                                            isThreeLine: true,
                                            leading: CircleAvatar(
                                              child: FittedBox(
                                                child: Text(
                                                  '${doc['quantidade']}x',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
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
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    ' Resumo',
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
                                'Valor da Comanda: R\$${totalComanda.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Desconto: R\$${desconto.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Valor Final: R\$${(totalComanda - desconto).toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    ' Opções',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ItemMenu(
                    icone: Icon(
                      Icons.money_off,
                      color: Colors.indigo,
                    ),
                    titulo: 'Inserir Desconto',
                    onTap: () => _abrirModalDesconto(context),
                  ),
                  ItemMenu(
                    icone: Icon(
                      Icons.receipt,
                      color: Colors.red,
                    ),
                    titulo: 'Fechar Comanda',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Fechar Comanda"),
                            content: new Text(
                                "Deseja realmente fechar esta comanda?"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Sim"),
                                onPressed: () {
                                  Firestore.instance
                                      .collection('caixas')
                                      .document(
                                          widget.estabelecimento.idCaixaAtual)
                                      .get()
                                      .then((doc) {
                                    doc.reference.updateData({
                                      'saldo': (double.tryParse(doc['saldo']) +
                                              totalComanda -
                                              desconto)
                                          .toStringAsFixed(2),
                                    });
                                  });
                                  Firestore.instance
                                      .collection('caixas')
                                      .document(
                                          widget.estabelecimento.idCaixaAtual)
                                      .collection('comandas')
                                      .document(widget.comanda.id.toString())
                                      .updateData({
                                    'isAberto': false,
                                    'total': totalComanda.toStringAsFixed(2),
                                    'desconto': desconto.toStringAsFixed(2),
                                  });
                                  Navigator.of(context).pop();
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
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
