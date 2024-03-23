import 'package:bro_app_to/utils/agente_model.dart';
import 'package:bro_app_to/utils/referido_model.dart';
import 'package:bro_app_to/utils/tarjeta_model.dart';
import 'package:bro_app_to/utils/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/registration/data/models/player_full_model.dart';
import '../utils/plan_model.dart';

class AgenteProvider extends ChangeNotifier {
  Agente _agente = Agente();

  void setAgente(Agente agente) {
    _agente = agente;
    notifyListeners();
  }

  Agente getAgente() {
    return _agente;
  }
}
