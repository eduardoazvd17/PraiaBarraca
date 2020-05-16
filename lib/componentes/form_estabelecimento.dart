import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormEstabelecimento extends StatefulWidget {
  final String idUsuario;
  final String idEstabelecimento;
  final String nome;
  final String local;

  FormEstabelecimento({
    @required this.idUsuario,
    this.idEstabelecimento,
    this.nome,
    this.local,
  });
  @override
  _FormEstabelecimentoState createState() => _FormEstabelecimentoState(
        TextEditingController(text: nome),
        TextEditingController(text: local),
      );
}

class _FormEstabelecimentoState extends State<FormEstabelecimento> {
  final TextEditingController nomeController;
  final TextEditingController localController;
  _FormEstabelecimentoState(this.nomeController, this.localController);

  _enviar() {
    if (nomeController.text.isEmpty || localController.text.isEmpty) {
      return;
    }
    if (this.widget.idEstabelecimento == null) {
      Firestore.instance.collection('estabelecimentos').document().setData({
        'dono': this.widget.idUsuario,
        'nome': nomeController.text,
        'idCaixaAtual': '0',
        'isCaixaAberto': false,
        'saldoAnterior': '0.00',
        'local': localController.text,
      });
    } else {
      Firestore.instance
          .collection('estabelecimentos')
          .document(this.widget.idEstabelecimento)
          .updateData({
        'nome': nomeController.text,
        'local': localController.text,
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
              this.widget.idEstabelecimento == null
                  ? 'Adicionar Estabelecimento'
                  : 'Editar Estabelecimento',
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
              controller: localController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Local',
                suffixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    this.widget.idEstabelecimento == null ? 'Enviar' : 'Salvar',
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
