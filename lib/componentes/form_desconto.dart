import 'package:flutter/material.dart';
import 'package:praiabarraca/modelos/comanda.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';

class FormDesconto extends StatefulWidget {
  final Estabelecimento estabelecimento;
  final Comanda comanda;
  final double total;
  final double desconto;
  final Function(double) alterarDesconto;

  FormDesconto({
    @required this.estabelecimento,
    @required this.comanda,
    @required this.total,
    @required this.desconto,
    @required this.alterarDesconto,
  });
  @override
  _FormDescontoState createState() => _FormDescontoState(
        TextEditingController(
          text: desconto == 0.00 ? '' : desconto.toStringAsFixed(2),
        ),
      );
}

class _FormDescontoState extends State<FormDesconto> {
  final TextEditingController descontoController;
  _FormDescontoState(this.descontoController);

  _enviar() {
    double valor = double.tryParse(descontoController.text);
    if (valor == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Valor Incorreto"),
            content:
                new Text("Apenas números são permitidos no campo desconto."),
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
    if (valor > widget.total) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Valor Incorreto"),
            content: new Text(
                "O valor de desconto não pode ser maior que o valor total da comanda."),
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
    widget.alterarDesconto(valor);
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
              this.widget.desconto == 0.00
                  ? 'Inserir Desconto'
                  : 'Alterar Desconto',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text('O valor da comanda é R\$${widget.total.toStringAsFixed(2)}'),
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: descontoController,
              decoration: InputDecoration(
                labelText: 'Valor',
                suffixIcon: Icon(Icons.money_off),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    this.widget.desconto == 0.00 ? 'Enviar' : 'Salvar',
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
