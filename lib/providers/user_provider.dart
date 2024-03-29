import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/utils/referido_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserModel _currentUser = const UserModel(username: '', password: '');
  List<Afiliado> afiliados = [];

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

  void updateLocalImage(String image) {
    _currentUser = _currentUser.copyWith(imageUrl: image);
    notifyListeners();
  }

  void setAfiliados(List<Afiliado> afiliado) {
    afiliados = afiliado;
    notifyListeners();
  }

  void logOut() async {
    _currentUser = const UserModel(username: '', password: '');
    afiliados.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', "");
    prefs.setString('password', "");
    notifyListeners();
  }
}
