class Agente {
  String? nombre;
  String? apellido;
  String? correo;
  String? usuario;
  String? pais;
  String? provincia;
  DateTime? birthDate;

  Agente({
    this.nombre,
    this.apellido,
    this.correo,
    this.usuario,
    this.pais,
    this.provincia,
    this.birthDate,
  });

  factory Agente.fromJson(Map<String, dynamic> json) {
    DateTime? birthDate;
    if (json['birthday'] != null) {
      // Convertir la cadena a un objeto DateTime
      birthDate = DateTime.parse(json['birthday']);
    }
    return Agente(
      nombre: json['name'],
      apellido: json['lastname'],
      correo: json['email'],
      usuario: json['username'] ?? 'No especificado',
      pais: json['country'],
      provincia: json['state'],
      birthDate: birthDate,
    );
  }
}

List<Agente> mapJsonToAgentes(List<dynamic> jsonData) {
  return jsonData.map((item) => Agente.fromJson(item)).toList();
}
