import '../entitites/user_entity.dart';

abstract class AuthenticationRepository {
  Future<bool> signIn(UserEntity user);
}
