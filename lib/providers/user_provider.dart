import 'package:flutter/material.dart';

import '../src/registration/data/models/player_full_model.dart';
import '../utils/plan_model.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerFullModel? _player;
  PlayerFullModel _temporalUser = const PlayerFullModel(name: '', email: '');
  Plan? _plan;

  void updateTemporalPlayer({
    String? userId,
    String? name,
    String? email,
    DateTime? birthDate,
    String? password,
    String? lastName,
    String? provincia,
    String? pais,
    String? categoria,
    String? club,
    String? logros,
    String? codigoReferido,
    String? altura,
    String? pieDominante,
    String? seleccion,
    String? categoriaSeleccion,
    String? position,
    String? dni,
  }) {
    _temporalUser = _temporalUser.copyWith(
        userId: userId,
        dni: dni,
        name: name,
        email: email,
        birthDate: birthDate,
        password: password,
        lastName: lastName,
        pais: pais,
        position: position,
        provincia: provincia,
        categoria: categoria,
        club: club,
        logrosIndividuales: logros,
        referralCode: codigoReferido,
        altura: altura,
        pieDominante: pieDominante,
        seleccionNacional: seleccion,
        categoriaSeleccion: categoriaSeleccion);
    notifyListeners();
  }

  PlayerFullModel getTemporalUser() {
    return _temporalUser;
  }

  void setPlayer(PlayerFullModel player) {
    _player = player;
    notifyListeners();
  }

  void selectPlan(Plan plan) {
    _plan = plan;
    notifyListeners();
  }

  Plan? getActualPlan() {
    return _plan;
  }

  PlayerFullModel? getPlayer() {
    return _player;
  }
}
