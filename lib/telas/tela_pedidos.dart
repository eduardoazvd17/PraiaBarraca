import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/lista_produtos_pedidos.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';
import 'package:praiabarraca/telas/tela_produtos_disponiveis.dart';

class TelaPedidos extends StatelessWidget {
  final Estabelecimento estabelecimento;
  final String idComanda;
  TelaPedidos({
    @required this.estabelecimento,
    @required this.idComanda,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos da Comanda $idComanda'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      TelaProdutosDisponiveis(estabelecimento, idComanda),
                ),
              );
            },
          )
        ],
      ),
      body: ListaProdutosPedidos(estabelecimento, idComanda),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  TelaProdutosDisponiveis(estabelecimento, idComanda),
            ),
          );
        },
      ),
    );
  }
}
