import 'package:bro_app_to/src/auth/domain/entitites/user_entity.dart';

import '../repositories/authentication_repository.dart';

class SignInUseCase {
  final AuthenticationRepository authenticationRepository;

  SignInUseCase({required this.authenticationRepository});

  Future<bool> call(UserEntity user) async {
    return await authenticationRepository.signIn(user);
  }
}
