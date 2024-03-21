import 'package:flutter/material.dart';

import '../src/registration/data/models/player_full_model.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerFullModel? _player;
  PlayerFullModel _temporalUser = const PlayerFullModel(name: '', email: '');

  void updateTemporalPlayer({
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

  // Método para obtener el usuario temporal
  PlayerFullModel getTemporalUser() {
    return _temporalUser;
  }

  void setPlayer(PlayerFullModel player) {
    _player = player;
    notifyListeners();
  }

  PlayerFullModel? getPlayer() {
    return _player;
  }
}
