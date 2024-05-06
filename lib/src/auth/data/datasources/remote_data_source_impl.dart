import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/providers/agent_provider.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/datasources/remote_data_source.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/agente_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../Screens/player/bottom_navigation_bar_player.dart';
import '../../../../utils/tarjeta_model.dart';
import '../../domain/entitites/user_entity.dart';

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
      playerProvider.setIsLoading(true);

      final response = await ApiClient().post(
        'auth/login',
        {'UserName': user.username, 'Password': user.password, 'fcm': fcmToken},
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final userData = jsonData["userInfo"];
        final isAgent = jsonData["isAgent"];

        _saveCredentialsLocally(rememberMe ? user.username : "",
            rememberMe ? user.password : "", isAgent);

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

  void _saveCredentialsLocally(
      String username, String password, bool? isAgent) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    if (isAgent != null) prefs.setBool('agente', isAgent);
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
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const CustomBottomNavigationBar()),
      );
    } else {
      final player = PlayerFullModel.fromJson(userData);
      final savedCards = jsonData["paymentMethods"]["data"];

      playerProvider.setCards(mapListToTarjetas(savedCards));
      playerProvider.setPlayer(player);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const CustomBottomNavigationBarPlayer()),
      );
    }
  }

  void _handleSignInError(
    BuildContext context,
    dynamic response,
    bool comingFromAutoLogin,
  ) {
    if (comingFromAutoLogin) {
      Navigator.pushNamed(context, '/intro');
    } else {
      final jsonData = json.decode(response.body);
      final errorMessage = jsonData["error"];
      showErrorSnackBar(context, errorMessage);
    }
  }

  void _handleSignInException(
    BuildContext context,
    dynamic e,
    bool comingFromAutoLogin,
  ) {
    if (comingFromAutoLogin) {
      Navigator.pushNamed(context, '/login');
    } else {
      print(e);
      playerProvider.setIsLoading(false);
      showErrorSnackBar(context, translations!["ErrorRetryMessage"]);
    }
  }
}
