import 'package:bro_app_to/src/auth/domain/entitites/user_entity.dart';
import 'package:flutter/material.dart';

import '../repositories/authentication_repository.dart';

class SignInUseCase {
  final AuthenticationRepository authenticationRepository;

  SignInUseCase({required this.authenticationRepository});

  Future<void> call(
      UserEntity user, BuildContext context, bool remember, bool co) async {
    return await authenticationRepository.signIn(user, context, remember, co);
  }
}
