import 'package:flutter/material.dart';

import '../../domain/entitites/user_entity.dart';

abstract class RemoteDataSource {
  Future<void> signIn(UserEntity user, BuildContext context);
}
