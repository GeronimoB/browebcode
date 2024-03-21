import 'package:bro_app_to/utils/tarjeta_model.dart';
import 'package:bro_app_to/utils/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/registration/data/models/player_full_model.dart';
import '../utils/plan_model.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerFullModel _player = const PlayerFullModel(name: '', email: '');
  PlayerFullModel _temporalUser = const PlayerFullModel(name: '', email: '');
  Plan? _plan;
  List<Tarjeta> _savedCards = [];
  Tarjeta? selectedCard;
  String? videoPathToUpload;
  Uint8List? imagePathToUpload;
  List<Video> userVideos = [];

  void updateTemporalPlayer({
    String? customerStripeId,
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
        customerStripeId: customerStripeId,
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

  void setCards(List<Tarjeta> cards) {
    _savedCards = cards;
    notifyListeners();
  }

  void setSelectedCard(Tarjeta card) {
    selectedCard = card;
    notifyListeners();
  }

  List<Tarjeta>? getSavedCards() {
    return _savedCards;
  }

  void updateDataToUpload(String? video, Uint8List? image) {
    imagePathToUpload = image;
    videoPathToUpload = video;
    notifyListeners();
  }

  void setNewUser() {
    _player = _temporalUser;
    notifyListeners();
  }

  void setUserVideos(List<Video> videos) {
    userVideos.clear();
    userVideos.addAll(videos);
    notifyListeners();
  }
}
