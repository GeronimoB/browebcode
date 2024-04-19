class Agente {
  String? userId;
  String? nombre;
  String? apellido;
  String? correo;
  String? usuario;
  String? pais;
  String? provincia;
  DateTime? birthDate;
  String? imageUrl;

  Agente({
    this.userId,
    this.nombre,
    this.apellido,
    this.correo,
    this.usuario,
    this.pais,
    this.provincia,
    this.birthDate,
    this.imageUrl,
  });

  Agente copyWith({
    String? userId,
    String? nombre,
    String? apellido,
    String? correo,
    String? usuario,
    String? pais,
    String? provincia,
    DateTime? birthDate,
    String? imageUrl,
  }) {
    return Agente(
        userId: userId ?? this.userId,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        correo: correo ?? this.correo,
        usuario: usuario ?? this.usuario,
        birthDate: birthDate ?? this.birthDate,
        pais: pais ?? this.pais,
        provincia: provincia ?? this.provincia,
        imageUrl: imageUrl ?? this.imageUrl);
  }

  factory Agente.fromJson(Map<String, dynamic> json) {
    DateTime? birthDate;
    if (json['birthday'] != null) {
      // Convertir la cadena a un objeto DateTime
      birthDate = DateTime.parse(json['birthday']);
    }
    return Agente(
        userId: json['user_id'].toString(),
        nombre: json['name'],
        apellido: json['lastname'],
        correo: json['email'],
        usuario: json['username'] ?? 'No especificado',
        pais: json['country'],
        provincia: json['state'],
        birthDate: birthDate,
        imageUrl: json["image_url"] ?? '');
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map['userId'] = userId;
    map['Name'] = nombre;
    map['LastName'] = apellido;
    map['Email'] = correo;
    map['UserName'] = usuario;
    map['Pais'] = pais;
    map['Provincia'] = provincia;
    map['Birthday'] = birthDate.toString();
    map['image_url'] = imageUrl;

    return map;
  }
}

List<Agente> mapJsonToAgentes(List<dynamic> jsonData) {
  return jsonData.map((item) => Agente.fromJson(item)).toList();
}
