import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';
import 'package:praiabarraca/modelos/caixa.dart';
import 'package:praiabarraca/telas/tela_detalhes_caixa.dart';

class ListaHistoricoCaixa extends StatelessWidget {
  final String idEstabelecimento;
  final DateTime dataSelecionada;
  ListaHistoricoCaixa(this.idEstabelecimento, this.dataSelecionada);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('caixas')
            .where('estabelecimento', isEqualTo: idEstabelecimento)
            .where('isAberto', isEqualTo: false)
            .where('abertura', isLessThanOrEqualTo: dataSelecionada)
            .where('abertura',
                isGreaterThanOrEqualTo:
                    dataSelecionada.subtract(Duration(days: 7)))
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshots.data.documents.length == 0) {
            return MensagemListaVazia('Nenhum registro de caixa encontrado');
          }
          return ListView.builder(
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshots.data.documents[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(
                      'Abertura: ${DateFormat('dd/MM/yyyy - H:mm').format((doc['abertura'] as Timestamp).toDate())}'),
                  subtitle: Text(
                      'Fechamento: ${DateFormat('dd/MM/yyyy - H:mm').format((doc['fechamento'] as Timestamp).toDate())}'),
                  trailing: Text(
                      'Total: R\$${double.tryParse(doc['saldo']).toStringAsFixed(2)}'),
                  onTap: () {
                    Caixa caixa = new Caixa(
                      id: doc.documentID,
                      estabelecimento: doc['estabelecimento'],
                      abertura: (doc['abertura'] as Timestamp).toDate(),
                      fechamento: (doc['fechamento'] as Timestamp).toDate(),
                      valorRetirada: double.tryParse(doc['valorRetirada']),
                      isAberto: false,
                      saldo: double.tryParse(doc['saldo']),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TelaDetalhesCaixa(caixa),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
