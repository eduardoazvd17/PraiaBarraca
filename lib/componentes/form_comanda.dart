import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

class FormComanda extends StatefulWidget {
  final String idCaixa;
  final String idComanda;
  final String nome;
  final String telefone;
  final int comandasCriadas;

  FormComanda({
    @required this.idCaixa,
    this.idComanda,
    this.nome,
    this.telefone,
    this.comandasCriadas,
  });
  @override
  _FormComandaState createState() => _FormComandaState(
        TextEditingController(text: nome == null ? '' : nome),
        TextEditingController(text: telefone == null ? '' : telefone),
      );
}

class _FormComandaState extends State<FormComanda> {
  final TextEditingController nomeController;
  final TextEditingController telefoneController;
  _FormComandaState(this.nomeController, this.telefoneController);

  _enviar() {
    if (nomeController.text.isEmpty || telefoneController.text.isEmpty) {
      return;
    }
    if (telefoneController.text.length < 15) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Celular Incorreto"),
            content: new Text("Digite o ddd + numero completo."),
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
    if (this.widget.idComanda == null) {
      Firestore.instance
          .collection('caixas')
          .document(widget.idCaixa)
          .collection('comandas')
          .document((widget.comandasCriadas + 1).toString())
          .setData({
        'nomeCliente': nomeController.text,
        'telefoneCliente': telefoneController.text,
        'total': '0.00',
        'isAberto': true,
      });
      Firestore.instance
          .collection('caixas')
          .document(widget.idCaixa)
          .updateData({
        'comandasCriadas': widget.comandasCriadas + 1,
      });
    } else {
      Firestore.instance
          .collection('caixas')
          .document(widget.idCaixa)
          .collection('comandas')
          .document(widget.idComanda)
          .updateData({
        'nomeCliente': nomeController.text,
        'telefoneCliente': telefoneController.text,
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
              this.widget.idComanda == null ? 'Nova Comanda' : 'Editar Comanda',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextField(
              maxLines: 1,
              controller: nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Cliente',
                suffixIcon: Icon(Icons.person),
              ),
            ),
            MaskedTextField(
              maxLength: 15,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              maskedTextFieldController: telefoneController,
              mask: "(xx) xxxxx-xxxx",
              inputDecoration: InputDecoration(
                labelText: 'Celular',
                suffixIcon: Icon(Icons.phone_iphone),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    this.widget.idComanda == null ? 'Enviar' : 'Salvar',
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
