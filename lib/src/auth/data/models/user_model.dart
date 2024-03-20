import '../../domain/entitites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String username,
    required String password,
  }) : super(
          username: username,
          password: password,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      password: json['email'],
    );
  }
}
