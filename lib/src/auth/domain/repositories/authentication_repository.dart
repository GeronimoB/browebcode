import 'package:flutter/material.dart';

import '../entitites/user_entity.dart';

abstract class AuthenticationRepository {
  Future<void> signIn(UserEntity user, BuildContext context, bool r);
}
