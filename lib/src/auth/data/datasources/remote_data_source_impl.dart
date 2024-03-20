import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/datasources/remote_data_source.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'dart:convert';
import '../../domain/entitites/user_entity.dart';
import 'package:http/http.dart' as http;

class RemoteDataSourceImpl implements RemoteDataSource {
  final PlayerProvider playerProvider;

  RemoteDataSourceImpl(this.playerProvider);

  @override
  Future<bool> signIn(UserEntity user) async {
    print("intentando logueaar");
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.41:8080/auth/login'), // URL de la solicitud POST para iniciar sesión
        body: {
          'UserName': user.username,
          'Password': user.password,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final player = PlayerFullModel.fromJson(jsonData["userInfo"]);
        playerProvider.setPlayer(player);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
