import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_comanda.dart';
import 'package:praiabarraca/componentes/lista_comandas.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';

class TelaComandas extends StatefulWidget {
  final Estabelecimento estabelecimento;
  TelaComandas(this.estabelecimento);
  @override
  _TelaComandasState createState() => _TelaComandasState();
}

class _TelaComandasState extends State<TelaComandas> {
  int comandasCriadas;

  _modalAdicionarComanda(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return FormComanda(
            idCaixa: widget.estabelecimento.idCaixaAtual,
            comandasCriadas: comandasCriadas,
          );
        });
  }

  Widget build(BuildContext context) {
    Firestore.instance
        .collection('caixas')
        .document(widget.estabelecimento.idCaixaAtual)
        .get()
        .then((doc) {
      setState(() {
        comandasCriadas = doc['comandasCriadas'] as int;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciamento de Comandas'),
      ),
      body: ListaComandas(widget.estabelecimento),
      floatingActionButton: FloatingActionButton(
        child: comandasCriadas == null
            ? CircularProgressIndicator()
            : Icon(Icons.add),
        onPressed: comandasCriadas == null
            ? null
            : () => _modalAdicionarComanda(context),
      ),
    );
  }
}
