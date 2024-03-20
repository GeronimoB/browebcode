import 'package:flutter/material.dart';

import '../../domain/entitites/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final RemoteDataSource remoteDataSource;

  AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> signIn(UserEntity user, BuildContext context) async => remoteDataSource.signIn(user, context);
}
