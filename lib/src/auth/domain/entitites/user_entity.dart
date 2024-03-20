import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String username;
  final String password;

  const UserEntity({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
