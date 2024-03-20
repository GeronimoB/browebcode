import '../../domain/entitites/user_entity.dart';

abstract class RemoteDataSource {
  Future<bool> signIn(UserEntity user);
}
