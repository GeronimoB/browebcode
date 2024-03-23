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

  Agente copyWith({
    String? nombre,
    String? apellido,
    String? correo,
    String? usuario,
    String? pais,
    String? provincia,
    DateTime? birthDate,
  }) {
    return Agente(
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      correo: correo ?? this.correo,
      usuario: usuario ?? this.usuario,
      birthDate: birthDate ?? this.birthDate,
      pais: pais ?? this.pais,
      provincia: provincia ?? this.provincia,
    );
  }

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

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    map['name'] = nombre;
    map['lastname'] = apellido;
    map['email'] = correo;
    map['username'] = usuario;
    map['country'] = pais;
    map['state'] = provincia;
    map['birthday'] = provincia.toString();

    return map;
  }
}

List<Agente> mapJsonToAgentes(List<dynamic> jsonData) {
  return jsonData.map((item) => Agente.fromJson(item)).toList();
}
