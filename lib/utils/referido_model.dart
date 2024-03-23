class Afiliado {
  String email;
  double comision;

  Afiliado({required this.email, required this.comision});

  factory Afiliado.fromJson(Map<String, dynamic> json) {
    return Afiliado(
      email: json['email'],
      comision: json['comision'],
    );
  }
}

List<Afiliado> mapListToAfiliados(List<dynamic> lista) {
  return lista.map((item) => Afiliado.fromJson(item)).toList();
}
