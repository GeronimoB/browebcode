import '../../domain/entitites/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/remote_data_source.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final RemoteDataSource remoteDataSource;

  AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> signIn(UserEntity user) async => remoteDataSource.signIn(user);
}
