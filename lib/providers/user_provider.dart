import 'package:flutter/material.dart';

import '../src/registration/data/models/player_full_model.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerFullModel? _player;

  void setPlayer(PlayerFullModel player) {
    _player = player;
    notifyListeners();
  }

  PlayerFullModel? getPlayer() {
    return _player;
  }

  // Aquí puedes añadir métodos adicionales para acceder o manipular el player según sea necesario
}
