import 'package:flutter/material.dart';

class Usuario {
  String id;
  String nome;
  String email;
  bool isAtivo;
  int maximoEstabelecimentos;
  DateTime inicioPlano;
  DateTime vencimentoPlano;
  String plano;

  Usuario({
    @required this.id,
    @required this.nome,
    @required this.email,
    @required this.isAtivo,
    @required this.maximoEstabelecimentos,
    this.inicioPlano,
    this.vencimentoPlano,
    this.plano,
  });
}
