import 'dart:convert';

import 'package:bro_app_to/Screens/chat_page.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class Matche extends StatefulWidget {
  const Matche({super.key});

  @override
  _MatcheState createState() => _MatcheState();
}

class _MatcheState extends State<Matche> {
  final List<bool> _isSelected = [];
  final List<bool> _isSelectedAux = [];
  final List<PlayerFullModel> players = [];
  late UserProvider provider;
  late UserModel user;
  bool isLoading = false;

  Future<void> fetchAgentMatches(String currentUserId) async {
    setState(() {
      isLoading = true;
    });
    final List<PlayerFullModel> playersAux = [];
    try {
      print("id: ${currentUserId}");
      QuerySnapshot agentMatchesSnapshot = await FirebaseFirestore.instance
          .collection('Matches')
          .doc('agente-$currentUserId')
          .collection('AgentMatches')
          .get();
      for (QueryDocumentSnapshot matchSnapshot in agentMatchesSnapshot.docs) {
        Map<String, dynamic>? data =
            matchSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          String playerId = data['playerId'] as String;
          playerId = playerId.split('-')[1];
          final response = await ApiClient().get('auth/player/$playerId');

          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);
            final player = jsonData['player'];
            final playerData = PlayerFullModel.fromJson(player);
            playersAux.add(playerData);
          } else {
            continue;
          }
        }
      }
      players.addAll(playersAux);
      _isSelected.clear();
      final llenando = List.generate(players.length, (index) => false);
      _isSelected.addAll(llenando);

      _isSelectedAux.addAll(llenando);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener los matches del agente: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<UserProvider>(context, listen: true);
    user = provider.getCurrentUser();
    fetchAgentMatches(user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Match',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          ),
        ),
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                ),
              )
            : players.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            final player = players[index];
                            return _buildMatchComponent(player, index, context);
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      "Aun no tienes match!",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                  ),
      ),
    );
  }

  Widget _buildMatchComponent(
      PlayerFullModel player, int index, BuildContext context) {
    DateTime? birthDate = player.birthDate;

    String formattedDate =
        birthDate != null ? DateFormat('yyyy-MM-dd').format(birthDate) : '';
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isSelectedAux[index] = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _isSelectedAux[index] = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isSelectedAux[index] = false;
          _isSelected[index] = !_isSelected[index];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        height: _isSelected[index] ? 260 : 109,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          gradient: _isSelectedAux[index]
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 180, 64),
                    Color.fromARGB(255, 0, 225, 80),
                    Color.fromARGB(255, 0, 178, 63),
                  ], // Colores de tu gradiente
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(
            _isSelected[index] ? 54 : 109,
          ),
          boxShadow: _isSelected[index]
              ? [
                  const CustomBoxShadow(
                      color: Color(0xff05FF00), blurRadius: 10)
                ]
              : null,
          border: Border.all(
            color: const Color(0xff00F056),
            width: _isSelected[index] ? 2 : 1,
          ),
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/fot.png',
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/fot.png',
                          width: 107,
                          height: 107,
                          fit: BoxFit.fill,
                        );
                      },
                      image: player.userImage ?? '',
                      width: 107,
                      height: 107,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${player.name} ${player.lastName}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$formattedDate - Sub ${player.categoria}',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          '${player.provincia}, ${player.pais}',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _isSelected[index] ? 1.0 : 0.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      '${player.club}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      player.logrosIndividuales ?? '',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Selección Nacional ${player.seleccionNacional} ${player.categoriaSeleccion}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _isSelected[index] ? 1.0 : 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextButton(
                        onTap: () {
                          final friend = UserModel.fromPlayer(player);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        friend: friend,
                                      )));
                        },
                        text: '¡Vamos al Chat!',
                        buttonPrimary: false,
                        width: 145,
                        height: 38),
                    CustomTextButton(
                        text: 'Ver Perfil',
                        buttonPrimary: true,
                        width: 135,
                        height: 32)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
