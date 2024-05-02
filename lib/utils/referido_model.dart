class Afiliado {
  String email;
  double comision;

  Afiliado({required this.email, required this.comision});

  factory Afiliado.fromJson(Map<String, dynamic> json) {
    print(json['amount']);
    return Afiliado(
      email: json['email'] ?? '',
      comision: json['amount'].toDouble() ?? 0,
    );
  }
}

List<Afiliado> mapListToAfiliados(List<dynamic> lista) {
  return lista.map((item) => Afiliado.fromJson(item)).toList();
}
