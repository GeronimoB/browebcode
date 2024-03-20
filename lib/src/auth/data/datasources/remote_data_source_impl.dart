import 'package:bro_app_to/Screens/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/datasources/remote_data_source.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../../Screens/bottom_navigation_bar_player.dart';
import '../../domain/entitites/user_entity.dart';
import 'package:http/http.dart' as http;

class RemoteDataSourceImpl implements RemoteDataSource {
  final PlayerProvider playerProvider;

  RemoteDataSourceImpl(this.playerProvider);

  @override
  Future<void> signIn(UserEntity user, BuildContext context) async {
    print("intentando logueaar");
    try {
      final response = await http.post(
        Uri.parse(Uri.encodeFull(
            '${ApiConstants.baseUrl}/auth/login')), // URL de la solicitud POST para iniciar sesión
        body: {
          'UserName': user.username,
          'Password': user.password,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final player = PlayerFullModel.fromJson(jsonData["userInfo"]);
        final isAgent = jsonData["isAgent"];
        if (isAgent) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CustomBottomNavigationBar()),
          );
        } else {
          playerProvider.setPlayer(player);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CustomBottomNavigationBarPlayer()),
          );
        }
      } else {
        final jsonData = json.decode(response.body);
        final errorMessage = jsonData["error"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              errorMessage,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  fontSize: 12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Ha ocurrido un error intentelo de nuevo",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                fontSize: 12),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      false;
    }
  }
}
