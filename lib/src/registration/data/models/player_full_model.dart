import 'package:bro_app_to/src/registration/domain/entities/player_full_entity.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';

@immutable
class PlayerFullModel extends PlayerFullEntity {
  const PlayerFullModel({
    final String? customerStripeId,
    final String? userId,
    final String? uid,
    final String? name,
    final String? lastName,
    final String? email,
    final String? referralCode,
    final bool? isAgent,
    final DateTime? birthDate,
    final String? dni,
    final String? direccion,
    final String? password,
    final String? pais,
    final String? provincia,
    final String? altura,
    final String? categoria,
    final String? club,
    final String? logrosIndividuales,
    final String? pieDominante,
    final String? seleccionNacional,
    final String? categoriaSeleccion,
    final String? position,
    final DateTime? dateCreated,
    final DateTime? dateUpdated,
    final String? userImage,
    final bool verificado = false,
    final bool emailVerified = false,
    final bool registroCompleto = false,
  }) : super(
          customerStripeId: customerStripeId,
          userId: userId,
          uid: uid,
          name: name,
          lastName: lastName,
          email: email,
          password: password,
          referralCode: referralCode,
          isAgent: isAgent,
          birthDate: birthDate,
          dni: dni,
          direccion: direccion,
          position: position,
          pais: pais,
          provincia: provincia,
          altura: altura,
          categoria: categoria,
          club: club,
          logrosIndividuales: logrosIndividuales,
          pieDominante: pieDominante,
          seleccionNacional: seleccionNacional,
          categoriaSeleccion: categoriaSeleccion,
          dateCreated: dateCreated,
          dateUpdated: dateUpdated,
          userImage: userImage,
          verificado: verificado,
          emailVerified: emailVerified,
          registroCompleto: registroCompleto,
        );

  @override
  PlayerFullModel copyWith({
    String? customerStripeId,
    String? userId,
    String? uid,
    String? name,
    String? lastName,
    String? email,
    String? referralCode,
    String? password,
    bool? isAgent,
    DateTime? birthDate,
    String? dni,
    String? direccion,
    String? position,
    String? pais,
    String? provincia,
    String? altura,
    String? categoria,
    String? club,
    String? logrosIndividuales,
    String? pieDominante,
    String? seleccionNacional,
    String? categoriaSeleccion,
    DateTime? dateCreated,
    DateTime? dateUpdated,
    String? userImage,
    bool? verificado,
    bool? emailVerified,
    bool? registroCompleto,
  }) {
    return PlayerFullModel(
      customerStripeId: customerStripeId ?? this.customerStripeId,
      userId: userId ?? this.userId,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      email: email ?? this.email,
      position: position ?? this.position,
      referralCode: referralCode ?? this.referralCode,
      isAgent: isAgent ?? this.isAgent,
      birthDate: birthDate ?? this.birthDate,
      dni: dni ?? this.dni,
      direccion: direccion ?? this.direccion,
      pais: pais ?? this.pais,
      provincia: provincia ?? this.provincia,
      altura: altura ?? this.altura,
      categoria: categoria ?? this.categoria,
      club: club ?? this.club,
      logrosIndividuales: logrosIndividuales ?? this.logrosIndividuales,
      pieDominante: pieDominante ?? this.pieDominante,
      seleccionNacional: seleccionNacional ?? this.seleccionNacional,
      categoriaSeleccion: categoriaSeleccion ?? this.categoriaSeleccion,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      userImage: userImage ?? this.userImage,
      verificado: verificado ?? this.verificado,
      emailVerified: emailVerified ?? this.emailVerified,
      registroCompleto: registroCompleto ?? this.registroCompleto,
    );
  }

  factory PlayerFullModel.fromJson(Map<String, dynamic> json) {
    DateTime? birthDate;
    if (json['birthday'] != null) {
      birthDate = DateTime.parse(json['birthday']);
    }

    return PlayerFullModel(
      customerStripeId: json['stripe_customer_id'],
      uid: json['id'].toString(),
      userId: json['user_id'].toString(),
      name: json['name'] ?? '',
      lastName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      referralCode: json['referral_code'] ?? '',
      isAgent: json['isAgent'] ?? false,
      birthDate: birthDate,
      dni: json['DNI'] ?? '',
      direccion: json['direccion'] ?? '',
      pais: json['pais'] ?? '',
      provincia: json['provincia'] ?? '',
      altura: json['altura'] ?? '',
      categoria: json['categoria'] ?? '',
      club: json['club'] ?? '',
      position: json['posicion_jugador'] ?? '',
      logrosIndividuales: json['logros_individuales'] ?? '',
      pieDominante: json['pie_dominante'] ?? '',
      seleccionNacional: json['seleccion_nacional'] ?? '',
      categoriaSeleccion: json['categoria_seleccion'] ?? '',
      dateCreated: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      dateUpdated: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      userImage: json['image_url'] ?? '',
      verificado: json['verificado'] ?? false,
      emailVerified: json['email_confirmed'] ?? false,
      registroCompleto: json['registroCompleto'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    if (userId != null) map['userId'] = userId;
    if (name != null) map['Name'] = name;
    if (lastName != null) map['LastName'] = lastName;
    if (email != null) map['Email'] = email;
    if (referralCode != null) map['CodigoAfiliado'] = referralCode;
    if (password != null) map['Password'] = password;
    if (birthDate != null) map['Birthday'] = birthDate.toString();
    if (dni != null) map['DNI'] = dni;
    if (direccion != null) map['Direccion'] = direccion;
    if (pais != null) map['Pais'] = pais;
    if (position != null) map['PosicionJugador'] = position;
    if (provincia != null) map['Provincia'] = provincia;
    if (altura != null) map['Altura'] = altura;
    if (categoria != null) map['Categoria'] = categoria;
    if (club != null) map['Club'] = club;
    map['LogrosIndividuales'] = logrosIndividuales ?? '';
    if (pieDominante != null) map['PieDominante'] = pieDominante;
    if (seleccionNacional != null) map['SeleccionNacional'] = seleccionNacional;
    map['CategoriaSeleccion'] = categoriaSeleccion ?? '';
    if (userImage != null) map['userImage'] = userImage;
    map['fcm'] = fcmToken;
    return map;
  }
}
