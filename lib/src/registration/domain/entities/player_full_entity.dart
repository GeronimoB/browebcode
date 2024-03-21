import 'package:equatable/equatable.dart';

class PlayerFullEntity extends Equatable {
  final String? uid;

  final String? name;

  final String? lastName;

  final String? email;

  final String? referralCode;

  final bool? isAgent;

  final DateTime? birthDate;

  final String? dni;

  final String? pais;

  final String? provincia;

  final String? altura;

  final String? categoria;

  final String? club;

  final String? password;
  final String? position;

  final String? logrosIndividuales;

  final String? pieDominante;

  final String? seleccionNacional;

  final String? categoriaSeleccion;

  final DateTime? dateCreated;

  final DateTime? dateUpdated;
  final String? userImage;

  const PlayerFullEntity({
    this.uid,
    this.name,
    this.lastName,
    this.email,
    this.referralCode,
    this.isAgent,
    this.birthDate,
    this.dni,
    this.position,
    this.pais,
    this.provincia,
    this.altura,
    this.categoria,
    this.club,
    this.logrosIndividuales,
    this.pieDominante,
    this.seleccionNacional,
    this.categoriaSeleccion,
    this.dateCreated,
    this.dateUpdated,
    this.userImage,
    this.password,
  });

  PlayerFullEntity copyWith({
    String? uid,
    String? name,
    String? lastName,
    String? email,
    String? referralCode,
    bool? isAgent,
    DateTime? birthDate,
    String? dni,
    String? pais,
    String? provincia,
    String? altura,
    String? categoria,
    String? logrosIndividuales,
    String? club,
    String? position,
    String? pieDominante,
    String? seleccionNacional,
    String? categoriaSeleccion,
    DateTime? dateCreated,
    DateTime? dateUpdated,
    String? userImage,
    String? password,
  }) {
    return PlayerFullEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      referralCode: referralCode ?? this.referralCode,
      isAgent: isAgent ?? this.isAgent,
      birthDate: birthDate ?? this.birthDate,
      password: password ?? this.password,
      dni: dni ?? this.dni,
      position: position ?? this.position,
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
    );
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        lastName,
        email,
        referralCode,
        isAgent,
        birthDate,
        dni,
        position,
        pais,
        provincia,
        altura,
        password,
        categoria,
        club,
        logrosIndividuales,
        pieDominante,
        seleccionNacional,
        categoriaSeleccion,
        dateCreated,
        dateUpdated,
        userImage,
      ];
}
