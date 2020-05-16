import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/modelos/caixa.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';

class FormCaixa extends StatefulWidget {
  final Estabelecimento estabelecimento;
  FormCaixa(this.estabelecimento);

  @override
  _FormCaixaState createState() => _FormCaixaState(
      TextEditingController(text: estabelecimento.saldoAnterior.toString()));
}

class _FormCaixaState extends State<FormCaixa> {
  TextEditingController valorController;
  _FormCaixaState(this.valorController);
  Caixa caixa;
  bool isCaixaAberto;
  bool carregaPagina = false;

  _enviar() {
    double valor = double.tryParse(valorController.text);
    if (valor == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Valor Incorreto"),
            content: new Text("Apenas números são permitidos no campo valor."),
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

    if (!isCaixaAberto) {
      if (valor < widget.estabelecimento.saldoAnterior) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Valor Incorreto"),
              content: new Text(
                  "No ulitmo caixa restou R\$${widget.estabelecimento.saldoAnterior.toStringAsFixed(2)}, portanto deve ser aberto a partir desde valor."),
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
      Firestore.instance.collection('caixas').document().setData({
        'estabelecimento': widget.estabelecimento.id,
        'comandasCriadas': 0,
        'abertura': DateTime.now(),
        'isAberto': true,
        'saldo': valor.toString()
      });
      Firestore.instance
          .collection('caixas')
          .where('estabelecimento', isEqualTo: widget.estabelecimento.id)
          .where('isAberto', isEqualTo: true)
          .getDocuments()
          .then((docs) {
        for (var doc in docs.documents) {
          Firestore.instance
              .collection('estabelecimentos')
              .document(widget.estabelecimento.id)
              .updateData({
            'idCaixaAtual': doc.documentID,
            'isCaixaAberto': true,
            'saldoAnterior': '0.00',
          });
        }
      });
    } else {
      if (valor > caixa.saldo) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Valor Incorreto"),
              content: new Text(
                  "O valor disponivel para retirada é de R\$${caixa.saldo}"),
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
      Firestore.instance.collection('caixas').document(caixa.id).updateData({
        'valorRetirada': valor.toStringAsFixed(2),
        'fechamento': DateTime.now(),
        'isAberto': false,
      });
      Firestore.instance
          .collection('estabelecimentos')
          .document(caixa.estabelecimento)
          .updateData({
        'idCaixaAtual': '0',
        'isCaixaAberto': false,
        'saldoAnterior': (caixa.saldo - valor).toString(),
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Firestore.instance
        .collection('caixas')
        .where('estabelecimento', isEqualTo: widget.estabelecimento.id)
        .where('isAberto', isEqualTo: true)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length == 0) {
        setState(() {
          isCaixaAberto = false;
          carregaPagina = true;
        });
      }
      for (var doc in docs.documents) {
        setState(() {
          caixa = new Caixa(
            id: doc.documentID,
            estabelecimento: widget.estabelecimento.id,
            abertura: (doc['abertura'] as Timestamp).toDate(),
            isAberto: doc['isAberto'] as bool,
            saldo: double.tryParse(doc['saldo']),
          );
          isCaixaAberto = true;
          carregaPagina = true;
        });
      }
    });
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: !carregaPagina
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    !isCaixaAberto
                        ? 'Abertura de Caixa'
                        : 'Fechamento de Caixa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  !isCaixaAberto
                      ? Text(
                          'Seu saldo anterior é de R\$' +
                              widget.estabelecimento.saldoAnterior
                                  .toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          'Seu saldo atual é de R\$' +
                              caixa.saldo.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                  TextField(
                    maxLines: 1,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: valorController,
                    decoration: InputDecoration(
                      labelText: !isCaixaAberto
                          ? 'Saldo Inicial'
                          : 'Valor de Retirada',
                      suffixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Enviar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        onPressed: _enviar,
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
