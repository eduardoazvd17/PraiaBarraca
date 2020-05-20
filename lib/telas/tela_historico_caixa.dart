import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praiabarraca/componentes/lista_historico_caixa.dart';
import 'package:praiabarraca/componentes/mensagem_lista_vazia.dart';

class TelaHistoricoCaixa extends StatefulWidget {
  final String idEstabelecimento;
  TelaHistoricoCaixa(this.idEstabelecimento);

  @override
  _TelaHistoricoCaixaState createState() => _TelaHistoricoCaixaState();
}

class _TelaHistoricoCaixaState extends State<TelaHistoricoCaixa> {
  DateTime dataSelecionada;
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('Histórico do Caixa'),
    );

    _abrirDatePicker(context) {
      showDatePicker(
        context: context,
        initialDate: dataSelecionada == null
            ? DateTime.now()
            : dataSelecionada
                .subtract(Duration(hours: 23, minutes: 59, seconds: 59)),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          dataSelecionada =
              pickedDate.add(Duration(hours: 23, minutes: 59, seconds: 59));
        });
      });
    }

    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          var altura = constraints.maxHeight;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: altura * 0.22,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(altura * 0.01),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(altura * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Filtro',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                    dataSelecionada == null
                                        ? 'Nenhuma data selecionada'
                                        : 'Data: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                dataSelecionada == null
                                    ? Container()
                                    : Text(
                                        '${DateFormat('dd/MM/yyyy').format(dataSelecionada)}'),
                                IconButton(
                                  icon: Icon(
                                    Icons.date_range,
                                    color: Colors.indigo,
                                  ),
                                  onPressed: () => _abrirDatePicker(context),
                                ),
                              ],
                            ),
                            Text(
                              'Será exbido todos os caixas que foram abertos no período de 7 dias que antecedem a data selecionada.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: altura * 0.78,
                child: dataSelecionada == null
                    ? Padding(
                        padding: EdgeInsets.all(altura * 0.01),
                        child: MensagemListaVazia(
                            'Informe a data desejada para exibir o histórico de caixas'),
                      )
                    : ListaHistoricoCaixa(
                        widget.idEstabelecimento, dataSelecionada),
              ),
            ],
          );
        },
      ),
    );
  }
}
