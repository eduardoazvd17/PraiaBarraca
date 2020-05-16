import 'package:flutter/material.dart';

class MensagemListaVazia extends StatelessWidget {
  final String mensagem;

  MensagemListaVazia(this.mensagem);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 50,
            child: FittedBox(
              child: Icon(Icons.beach_access),
            ),
          ),
          SizedBox(height: 10),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
