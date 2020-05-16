import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/componentes/form_pedidos.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';
import 'package:praiabarraca/modelos/produto.dart';

class ListaProdutosDisponiveis extends StatelessWidget {
  final Estabelecimento estabelecimento;
  final idComanda;
  ListaProdutosDisponiveis(this.estabelecimento, this.idComanda);

  _abrirModalAdicionarPedido(context, Produto produto) {
    //abre o modal que adicionar/edita o pedido deixando informar apenas a quantidade verificando se ja existe e se existir soma + a quantidade adicionada.
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return FormPedido(
            estabelecimento: estabelecimento,
            idComanda: idComanda,
            produto: produto,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('estabelecimentos')
            .document(estabelecimento.id)
            .collection('produtos')
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshots.data.documents.length == 0) {
            return MensagemListaVazia('Nenhum produto cadastrado');
          }
          return ListView.builder(
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshots.data.documents[index];
              Produto produto = new Produto(
                doc.documentID,
                doc['nome'],
                double.tryParse(
                  doc['valor'],
                ),
              );
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(
                    '${produto.nome}',
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    'R\$${produto.valor.toStringAsFixed(2)}',
                    overflow: TextOverflow.fade,
                  ),
                  onTap: () => _abrirModalAdicionarPedido(context, produto),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
