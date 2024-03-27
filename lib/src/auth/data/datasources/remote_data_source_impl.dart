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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../Screens/player/bottom_navigation_bar_player.dart';
import '../../../../utils/tarjeta_model.dart';
import '../../domain/entitites/user_entity.dart';
import 'package:http/http.dart' as http;

class RemoteDataSourceImpl implements RemoteDataSource {
  final PlayerProvider playerProvider;

  RemoteDataSourceImpl(this.playerProvider);

  @override
  Future<void> signIn(
    UserEntity user,
    BuildContext context,
    bool rememberMe,
    bool comingFromAutoLogin,
  ) async {
    try {
      print("intento");
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

        if (rememberMe) {
          _saveCredentialsLocally(user.username, user.password);
        }

        _handleSuccessfulSignIn(context, jsonData, userData);
      } else {
        _handleSignInError(context, response, comingFromAutoLogin);
      }
    } catch (e) {
      _handleSignInException(context, e, comingFromAutoLogin);
    } finally {
      playerProvider.setIsLoading(false);
    }
  }

  void _saveCredentialsLocally(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
  }

  void _handleSuccessfulSignIn(
    BuildContext context,
    dynamic jsonData,
    dynamic userData,
  ) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setCurrentUser(UserModel.fromJson(userData));

    final isAgent = jsonData["isAgent"];

    if (isAgent) {
      final agentProvider = Provider.of<AgenteProvider>(context, listen: false);
      agentProvider.setAgente(Agente.fromJson(userData));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
      );
    } else {
      final player = PlayerFullModel.fromJson(userData);
      final savedCards = jsonData["paymentMethods"]["data"];

      playerProvider.setCards(mapListToTarjetas(savedCards));
      playerProvider.setPlayer(player);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBottomNavigationBarPlayer()),
      );
    }
  }

  void _handleSignInError(
    BuildContext context,
    dynamic response,
    bool comingFromAutoLogin,
  ) {
    print("hay un error");
    if (comingFromAutoLogin) {
      Navigator.pushReplacementNamed(context, '/login');
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
  }

  void _handleSignInException(
    BuildContext context,
    dynamic e,
    bool comingFromAutoLogin,
  ) {
    if (comingFromAutoLogin) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print(e);
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
    }
  }
}
