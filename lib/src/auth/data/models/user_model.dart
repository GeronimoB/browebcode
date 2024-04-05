import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';

import '../../../../utils/agente_model.dart';
import '../../domain/entitites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String username,
    required String password,
    bool isAgent = false,
    String userId = '',
    String referralCode = '',
    String name = '',
    String lastName = '',
    String imageUrl = '',
  }) : super(
          username: username,
          password: password,
          isAgent: isAgent,
          userId: userId,
          referralCode: referralCode,
          name: name,
          lastName: lastName,
          imageUrl: imageUrl,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userid = json["user_id"] != null ? json["user_id"] : json["id"];
    return UserModel(
      username: json['username'] ?? '',
      userId: userid.toString(),
      isAgent: json["isAgent"],
      password: json['email'],
      referralCode: json['referral_code'] ?? '',
      name: json["name"],
      lastName: json["lastname"],
      imageUrl: json['image_url'] ?? '',
    );
  }

  factory UserModel.fromAgent(Agente agente) {
    return UserModel(
      username: agente.usuario!,
      password: '',
      isAgent: true,
      userId: agente.userId!,
      name: agente.nombre!,
      lastName: agente.apellido!,
      imageUrl: agente.imageUrl!,
    );
  }

  factory UserModel.fromPlayer(PlayerFullModel player) {
    return UserModel(
      username: '',
      password: '',
      isAgent: false,
      userId: player.userId!,
      name: player.name!,
      lastName: player.lastName!,
      imageUrl: player.userImage!,
    );
  }

  UserModel copyWith({
    String? nombre,
    String? apellido,
    String? correo,
    String? usuario,
    String? pais,
    String? provincia,
    DateTime? birthDate,
    String? referralCode,
    String? imageUrl,
  }) {
    return UserModel(
      userId: userId,
      username: usuario ?? username,
      password: '',
      referralCode: referralCode ?? this.referralCode,
      name: nombre ?? name,
      lastName: apellido ?? lastName,
      imageUrl: imageUrl ?? this.imageUrl,
      isAgent: isAgent,
    );
  }
}
