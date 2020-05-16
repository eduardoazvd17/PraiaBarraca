import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:praiabarraca/modelos/estabelecimento.dart';
import 'package:praiabarraca/modelos/produto.dart';

class FormPedido extends StatefulWidget {
  final Estabelecimento estabelecimento;
  final String idComanda;
  final Produto produto;
  final int quantidade;

  FormPedido({
    @required this.estabelecimento,
    @required this.idComanda,
    @required this.produto,
    this.quantidade,
  });
  @override
  _FormPedidoState createState() =>
      _FormPedidoState(quantidade == null ? 1 : quantidade);
}

class _FormPedidoState extends State<FormPedido> {
  int quantidade;
  _FormPedidoState(this.quantidade);

  _enviar() {
    if (this.widget.quantidade == null) {
      Firestore.instance
          .collection('caixas')
          .document(widget.estabelecimento.idCaixaAtual)
          .collection('comandas')
          .document(widget.idComanda)
          .collection('pedidos')
          .document(widget.produto.id)
          .get()
          .then((doc) {
        if (doc.data == null) {
          doc.reference.setData({
            'pedido': widget.produto.nome,
            'valor': widget.produto.valor.toStringAsFixed(2),
            'quantidade': quantidade,
          });
        } else {
          doc.reference.updateData({
            'quantidade': doc['quantidade'] + quantidade,
          });
        }
      });
    } else {
      Firestore.instance
          .collection('caixas')
          .document(widget.estabelecimento.idCaixaAtual)
          .collection('comandas')
          .document(widget.idComanda)
          .collection('pedidos')
          .document(widget.produto.id)
          .updateData({
        'quantidade': quantidade,
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
              this.widget.quantidade == null
                  ? 'Efetuar Pedido'
                  : 'Editar Pedido',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Produto: ${widget.produto.nome}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Quantidade:',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (quantidade >= 99) {
                        return;
                      }
                      quantidade++;
                    });
                  },
                ),
                Text(
                  quantidade.toString(),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantidade <= 1) {
                        return;
                      }
                      quantidade--;
                    });
                  },
                ),
              ],
            ),
            Text(
              'Valor: R\$${(widget.produto.valor * quantidade).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    this.widget.quantidade == null ? 'Enviar' : 'Salvar',
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
