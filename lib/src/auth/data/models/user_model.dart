import '../../domain/entitites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String username,
    required String password,
    bool isAgent = false,
    int userId = 0,
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
    return UserModel(
      username: json['username'] ?? '',
      userId: json["user_id"],
      isAgent: json["isAgent"],
      password: json['email'],
      referralCode: json['referral_code'] ?? '',
      name: json["name"],
      lastName: json["lastname"],
      imageUrl: json['image_url'],
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
      username: usuario ?? username,
      password: '',
      referralCode: referralCode ?? this.referralCode,
      name: nombre ?? name,
      lastName: apellido ?? lastName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
