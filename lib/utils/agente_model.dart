class Agente {
  String? nombre;
  String? apellido;
  String? correo;
  String? usuario;
  String? pais;
  String? provincia;

  Agente({
    this.nombre,
    this.apellido,
    this.correo,
    this.usuario,
    this.pais,
    this.provincia,
  });

  factory Agente.fromJson(Map<String, dynamic> json) {
    return Agente(
      nombre: json['name'],
      apellido: json['lastname'],
      correo: json['email'],
      usuario: json['username'] ?? 'No especificado',
      pais: json['country'], 
      provincia: json['state'], 
    );
  }
}

List<Agente> mapJsonToAgentes(List<dynamic> jsonData) {
  return jsonData.map((item) => Agente.fromJson(item)).toList();
}
