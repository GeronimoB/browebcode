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

  void updateAgent({required String fieldName, required String value}) {
    // Mapa que mapea los nombres de campo a los métodos correspondientes de copyWith
    final Map<String, Function> fieldMap = {
      'name': (String value) => _agente.copyWith(nombre: value),
      'email': (String value) => _agente.copyWith(correo: value),
      'birthdate': (String value) =>
          _agente.copyWith(birthDate: DateTime.tryParse(value)),
      'lastname': (String value) => _agente.copyWith(apellido: value),
      'provincia': (String value) => _agente.copyWith(provincia: value),
      'pais': (String value) => _agente.copyWith(pais: value),
      'username': (String value) => _agente.copyWith(usuario: value),
    };

    final Function? copyWithMethod = fieldMap[fieldName.toLowerCase()];

    if (copyWithMethod != null) {
      _agente = copyWithMethod(value);
      notifyListeners();
    }
  }

  void updateLocalImage(String image) {
    _agente = _agente.copyWith(imageUrl: image);
    notifyListeners();
  }

  void logOut() {
    _agente = Agente();
    notifyListeners();
  }
}
