import 'dart:convert';

import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/chat_page.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../src/auth/data/models/user_model.dart';

class MatchProfile extends StatefulWidget {
  final int userId;
  const MatchProfile({super.key, required this.userId});

  @override
  State<MatchProfile> createState() => _MatchProfileState();
}

class _MatchProfileState extends State<MatchProfile> {
  late UserProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<UserProvider>(context, listen: false);
    final currentUserId = provider.getCurrentUser().userId;
    _writeMatchData(widget.userId, currentUserId);
  }

  Future<void> _writeMatchData(int userId, String currentUserId) async {
    const uri = "auth/notification-message";
    Map<String, dynamic> body = {
      "title": "¡Tienes un nuevo Match!",
      "body":
          "${provider.getCurrentUser().name} ${provider.getCurrentUser().lastName} te ha hecho match al video...",
      "friendID": "jugador_$userId",
    };
    ApiClient().post(uri, body);
    await FirebaseFirestore.instance
        .collection('Matches')
        .doc('agente-$currentUserId')
        .collection('AgentMatches')
        .doc('jugador-$userId')
        .set(
      {
        'playerId': 'jugador-$userId',
        'createdAt': Timestamp.now(),
      },
    );

    await FirebaseFirestore.instance
        .collection('Matches')
        .doc('jugador-$userId')
        .collection('PlayerMatches')
        .doc('agente-$currentUserId')
        .set({
      'agentId': 'agente-$currentUserId',
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  const CustomBottomNavigationBar(initialIndex: 0)),
        );
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 44, 44, 44),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: FutureBuilder(
            future: _fetchUserData(widget.userId),
            builder: (context, AsyncSnapshot<PlayerFullModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Error al cargar la información del usuario'));
              } else {
                final userData = snapshot.data!;
                DateTime? birthDate = userData.birthDate;

                String formattedDate = birthDate != null
                    ? DateFormat('yyyy-MM-dd').format(birthDate)
                    : '';
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/jugador1.png',
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/jugador1.png',
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  image: userData.userImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Color(0xFF05FF00)),
                                onPressed: () =>
                                    Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomBottomNavigationBar(
                                              initialIndex: 0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${userData.name} ${userData.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDataRow(context,'fecha de nacimiento: ${formattedDate}'),
                      _buildDataRow(context, 'Provincia: ${userData.provincia}, ${userData.pais}'),
                      _buildDataRow(context, 'Altura: ${userData.altura} cm'),
                      _buildDataRow(
                          context, 'Pie Dominante: ${userData.pieDominante}'),
                      _buildDataRow(context, 'Posicion: ${userData.position}'),
                      _buildDataRow(
                          context, 'Categoria: ${userData.categoria}'),
                      _buildDataRow(
                          context, 'Escuela deportiva: ${userData.club}'),
                      _buildDataRow(context,
                          'Logros individuales: ${userData.logrosIndividuales}'),
                      _buildDataRow(context,
                          'Seleccion: ${userData.seleccionNacional} ${userData.categoriaSeleccion}'),
                      const SizedBox(height: 20),
                      CustomTextButton(
                          onTap: () {
                            final friend = UserModel.fromPlayer(userData);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          friend: friend,
                                        )));
                          },
                          text: '¡Vamos al Chat!',
                          buttonPrimary: false,
                          width: 154,
                          height: 40),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<PlayerFullModel> _fetchUserData(int id) async {
    final response = await ApiClient().get('auth/player/$id');
    try {
      if (response.statusCode == 200) {
        final userData =
            PlayerFullModel.fromJson(json.decode(response.body)["player"]);
        return userData;
      } else {
        throw Exception('Error al cargar la información del usuario');
      }
    } catch (e) {
      print(e);
      throw Exception('Error al cargar la información del usuario');
    }
  }

  Widget _buildDataRow(BuildContext context, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
