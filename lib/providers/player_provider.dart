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
  bool isLoading = false;
  int indexProcessingVideoFavoritePayment = 0;
  Video? videoProcessingFavoritePayment;
  bool isSubscriptionPayment = false;
  bool isNewSubscriptionPayment = false;

  void setVideoAndIndex(int index, Video video) {
    indexProcessingVideoFavoritePayment = index;
    videoProcessingFavoritePayment = video;
    notifyListeners();
  }

  void updateTemporalPlayer({
    String? customerStripeId,
    String? userId,
    String? name,
    String? email,
    DateTime? birthDate,
    DateTime? dateCreated,
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
    String? direccion,
    bool? registroCompleto,
  }) {
    _temporalUser = _temporalUser.copyWith(
      customerStripeId: customerStripeId,
      userId: userId,
      dni: dni,
      direccion: direccion,
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
      categoriaSeleccion: categoriaSeleccion,
      dateCreated: dateCreated,
      registroCompleto: registroCompleto,
    );
    notifyListeners();
  }

  void updatePlayer({required String fieldName, required String value}) {
    final Map<String, Function> fieldMap = {
      'name': (String value) => _player.copyWith(name: value),
      'email': (String value) => _player.copyWith(email: value),
      'birthdate': (String value) =>
          _player.copyWith(birthDate: DateTime.tryParse(value)),
      'password': (String value) => _player.copyWith(password: value),
      'lastname': (String value) => _player.copyWith(lastName: value),
      'provincia': (String value) => _player.copyWith(provincia: value),
      'pais': (String value) => _player.copyWith(pais: value),
      'categoria': (String value) => _player.copyWith(categoria: value),
      'club': (String value) => _player.copyWith(club: value),
      'logros': (String value) => _player.copyWith(logrosIndividuales: value),
      'codigoreferido': (String value) => _player.copyWith(referralCode: value),
      'altura': (String value) => _player.copyWith(altura: value),
      'piedominante': (String value) => _player.copyWith(pieDominante: value),
      'seleccion': (String value) => _player.copyWith(seleccionNacional: value),
      'categoriaseleccion': (String value) =>
          _player.copyWith(categoriaSeleccion: value),
      'position': (String value) => _player.copyWith(position: value),
      'dni': (String value) => _player.copyWith(dni: value),
      'direccion': (String value) => _player.copyWith(direccion: value),
    };

    final Function? copyWithMethod = fieldMap[fieldName.toLowerCase()];

    if (copyWithMethod != null) {
      _player = copyWithMethod(value);
      notifyListeners();
    }
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
    return _player.name == '' ? null : _player;
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

  void updateIsFavoriteById() {
    userVideos[indexProcessingVideoFavoritePayment].isFavorite =
        !userVideos[indexProcessingVideoFavoritePayment].isFavorite;
    notifyListeners();
  }

  void updateLocalImage(String image) {
    _player = _player.copyWith(userImage: image);
    notifyListeners();
  }

  void setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void logOut() {
    _player = const PlayerFullModel(name: '', email: '');
    _temporalUser = const PlayerFullModel(name: '', email: '');
    _plan = null;
    _savedCards.clear();
    selectedCard = null;
    videoPathToUpload = null;
    imagePathToUpload = null;
    userVideos.clear();
    isLoading = false;
    notifyListeners();
  }
}
