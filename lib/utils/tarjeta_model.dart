class Tarjeta {
  String? cardId;
  String? last4Numbers;
  String? displayBrand;

  Tarjeta({
    this.cardId,
    this.last4Numbers,
    this.displayBrand,
  });

  factory Tarjeta.fromJson(Map<String, dynamic> json) {
    return Tarjeta(
      cardId: json['id'],
      last4Numbers: json['card']['last4'],
      displayBrand: json['card']['brand'],
    );
  }
}

List<Tarjeta> mapListToTarjetas(List<dynamic> lista) {
  return lista.map((item) => Tarjeta.fromJson(item)).toList();
}
