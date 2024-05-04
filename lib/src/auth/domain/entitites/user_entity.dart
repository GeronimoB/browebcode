import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String username;
  final String password;
  final bool isAgent;
  final String userId;
  final String referralCode;
  final String name;
  final String lastName;
  final String imageUrl;
  final String subscription;
  final bool status;
  final bool verificado;
  final bool verificadoReferral;

  const UserEntity({
    required this.username,
    required this.password,
    this.isAgent = false,
    this.userId = '',
    this.referralCode = '',
    this.name = '',
    this.lastName = '',
    this.imageUrl = '',
    this.subscription = '',
    this.status = false,
    this.verificado = false,
    this.verificadoReferral = false,
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
        imageUrl,
        subscription,
        status,
        verificado,
        verificadoReferral
      ];
}
