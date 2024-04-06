import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/agente_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/referido_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserModel _currentUser = const UserModel(username: '', password: '');
  List<Afiliado> afiliados = [];
  int unreadTotalMessages = 0;

  void setCurrentUser(UserModel agente) {
    _currentUser = agente;
    notifyListeners();
  }

  UserModel getCurrentUser() {
    return _currentUser;
  }

  void updateRefCode(String code) {
    _currentUser = _currentUser.copyWith(referralCode: code);
    notifyListeners();
  }

  void updatePlan(String plan) {
    _currentUser = _currentUser.copyWith(subscription: plan);
    notifyListeners();
  }

  void updateUserFromPlayer(PlayerFullModel player) {
    _currentUser = _currentUser.copyWith(
        nombre: player.name,
        apellido: player.lastName,
        birthDate: player.birthDate,
        correo: player.email,
        pais: player.pais,
        provincia: player.provincia);
    notifyListeners();
  }

  void updateUserFromAgent(Agente agent) {
    _currentUser = _currentUser.copyWith(
      nombre: agent.nombre,
      apellido: agent.apellido,
      birthDate: agent.birthDate,
      correo: agent.correo,
      pais: agent.pais,
      provincia: agent.provincia,
    );
    notifyListeners();
  }

  void updateLocalImage(String image) {
    _currentUser = _currentUser.copyWith(imageUrl: image);
    notifyListeners();
  }

  void setAfiliados(List<Afiliado> afiliado) {
    afiliados = afiliado;
    notifyListeners();
  }

  void logOut() async {
    ApiClient().post(
      'auth/fcm',
      {"userId": _currentUser.userId},
    );
    _currentUser = const UserModel(username: '', password: '');
    afiliados.clear();
    unreadTotalMessages = 0;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', "");
    prefs.setString('password', "");
    prefs.remove(
      'agente',
    );
    notifyListeners();
  }
}
