import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:bro_app_to/providers/agent_provider.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/datasources/remote_data_source.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/agente_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../../Screens/player/bottom_navigation_bar_player.dart';
import '../../domain/entitites/user_entity.dart';
import 'package:http/http.dart' as http;

class RemoteDataSourceImpl implements RemoteDataSource {
  final PlayerProvider playerProvider;

  RemoteDataSourceImpl(this.playerProvider);

  @override
  Future<void> signIn(UserEntity user, BuildContext context) async {
    try {
      // Antes de hacer la solicitud, establece isLoading en true
      playerProvider.setIsLoading(true);

      final response = await ApiClient().post(
        'auth/login',
        {
          'UserName': user.username,
          'Password': user.password,
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final userData = jsonData["userInfo"];

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setCurrentUser(UserModel.fromJson(userData));

        final isAgent = jsonData["isAgent"];

        if (isAgent) {
          final agentProvider =
              Provider.of<AgenteProvider>(context, listen: false);
          agentProvider.setAgente(Agente.fromJson(userData));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CustomBottomNavigationBar()),
          );
        } else {
          final player = PlayerFullModel.fromJson(userData);
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
                fontSize: 12,
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print(e);
      // En caso de error, establece isLoading en false para quitar el loader
      playerProvider.setIsLoading(false);

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
              fontSize: 12,
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      // Independientemente de si hubo éxito o error, establece isLoading en false al final
      playerProvider.setIsLoading(false);
    }
  }
}
