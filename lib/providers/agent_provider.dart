import 'package:bro_app_to/utils/agente_model.dart';
import 'package:flutter/material.dart';

class AgenteProvider extends ChangeNotifier {
  Agente _agente = Agente();

  void setAgente(Agente agente) {
    _agente = agente;
    notifyListeners();
  }

  Agente getAgente() {
    return _agente;
  }

  void updateLocalImage(String image) {
    _agente = _agente.copyWith(imageUrl: image);
    notifyListeners();
  }
}
