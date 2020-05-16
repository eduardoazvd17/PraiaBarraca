import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_produto.dart';
import 'package:praiabarraca/componentes/lista_produtos.dart';

class TelaProdutos extends StatelessWidget {
  final String idEstabelecimento;
  TelaProdutos(this.idEstabelecimento);

  _modalAdicionarProduto(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return FormProduto(
            idEstabelecimento: idEstabelecimento,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _modalAdicionarProduto(context),
          ),
        ],
      ),
      body: ListaProdutos(idEstabelecimento),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar Produto',
        child: Icon(Icons.add),
        onPressed: () => _modalAdicionarProduto(context),
      ),
    );
  }
}
