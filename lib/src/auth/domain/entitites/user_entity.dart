import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String username;
  final String password;
  final bool isAgent;
  final int userId;
  final String referralCode;
  final String name;
  final String lastName;
  final String imageUrl;

  const UserEntity({
    required this.username,
    required this.password,
    this.isAgent = false,
    this.userId = 0,
    this.referralCode = '',
    this.name = '',
    this.lastName = '',
    this.imageUrl = '',
  });

  @override
  List<Object?> get props => [
        username,
        password,
        isAgent,
        userId,
        referralCode,
        name,
        lastName,
        imageUrl
      ];
}
