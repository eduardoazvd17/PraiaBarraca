import 'package:flutter/material.dart';

class Caixa {
  String id;
  String estabelecimento;
  DateTime abertura;
  DateTime fechamento;
  bool isAberto;
  double saldo;
  double valorRetirada;

  Caixa({
    @required this.id,
    @required this.estabelecimento,
    @required this.abertura,
    @required this.saldo,
    @required this.isAberto,
    this.fechamento,
    this.valorRetirada,
  });
}
