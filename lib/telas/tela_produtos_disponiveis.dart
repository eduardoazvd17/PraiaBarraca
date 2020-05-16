import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/lista_produtos_disponiveis.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';

class TelaProdutosDisponiveis extends StatelessWidget {
  final Estabelecimento estabelecimento;
  final String idComanda;
  TelaProdutosDisponiveis(this.estabelecimento, this.idComanda);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione um produto'),
      ),
      body: ListaProdutosDisponiveis(estabelecimento, idComanda),
    );
  }
}
