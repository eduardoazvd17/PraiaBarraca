import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormProduto extends StatefulWidget {
  final String idEstabelecimento;
  final String idProduto;
  final String nome;
  final double valor;

  FormProduto({
    @required this.idEstabelecimento,
    this.idProduto,
    this.nome,
    this.valor,
  });
  @override
  _FormProdutoState createState() => _FormProdutoState(
        TextEditingController(text: nome),
        TextEditingController(
            text: valor == null ? '' : valor.toStringAsFixed(2)),
      );
}

class _FormProdutoState extends State<FormProduto> {
  final TextEditingController nomeController;
  final TextEditingController valorController;
  _FormProdutoState(this.nomeController, this.valorController);

  _enviar() {
    if (nomeController.text.isEmpty || valorController.text.isEmpty) {
      return;
    }
    if (double.tryParse(valorController.text) == null) {
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
    if (this.widget.idProduto == null) {
      Firestore.instance
          .collection('estabelecimentos')
          .document(widget.idEstabelecimento)
          .collection('produtos')
          .document()
          .setData({
        'nome': nomeController.text,
        'valor': double.tryParse(valorController.text).toString(),
      });
    } else {
      Firestore.instance
          .collection('estabelecimentos')
          .document(widget.idEstabelecimento)
          .collection('produtos')
          .document(widget.idProduto)
          .updateData({
        'nome': nomeController.text,
        'valor': double.tryParse(valorController.text).toString(),
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.widget.idProduto == null
                  ? 'Adicionar Produto'
                  : 'Editar Produto',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextField(
              maxLines: 1,
              controller: nomeController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nome',
                suffixIcon: Icon(Icons.assignment),
              ),
            ),
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: valorController,
              decoration: InputDecoration(
                labelText: 'Valor',
                suffixIcon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    this.widget.idProduto == null ? 'Enviar' : 'Salvar',
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
