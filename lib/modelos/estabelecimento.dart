class Estabelecimento {
  String id;
  String dono;
  bool isCaixaAberto;
  String nome;
  String local;
  double saldoAnterior;
  String idCaixaAtual;

  Estabelecimento(
      {this.id,
      this.dono,
      this.isCaixaAberto,
      this.nome,
      this.local,
      this.idCaixaAtual,
      this.saldoAnterior});
}
