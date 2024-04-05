import 'dart:convert';

import 'package:bro_app_to/Screens/chat_page.dart';
import 'package:bro_app_to/components/avatar_placeholder.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/utils/agente_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../src/auth/data/models/user_model.dart';
import '../../utils/api_client.dart';

class MatchePlayer extends StatefulWidget {
  const MatchePlayer({super.key});

  @override
  _MatcheState createState() => _MatcheState();
}

class _MatcheState extends State<MatchePlayer> {
  final List<bool> _isSelected = [];
  final List<bool> _isSelectedAux = [];
  final List<Agente> agentes = [];
  late UserProvider provider;
  late UserModel user;
  bool isLoading = false;

  Future<void> fetchPlayerMatches(String currentUserId) async {
    setState(() {
      isLoading = true;
    });
    final List<Agente> playersAux = [];
    try {
      print("id: ${currentUserId}");
      QuerySnapshot agentMatchesSnapshot = await FirebaseFirestore.instance
          .collection('Matches')
          .doc('jugador-$currentUserId')
          .collection('PlayerMatches')
          .get();
      for (QueryDocumentSnapshot matchSnapshot in agentMatchesSnapshot.docs) {
        Map<String, dynamic>? data =
            matchSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          String agentId = data['agentId'] as String;
          agentId = agentId.split('-')[1];
          final response = await ApiClient().get('auth/agent/$agentId');

          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);
            final player = jsonData['player'];
            final playerData = Agente.fromJson(player);
            playersAux.add(playerData);
          } else {
            continue;
          }
        }
      }
      agentes.addAll(playersAux);
      _isSelected.clear();
      final llenando = List.generate(agentes.length, (index) => false);
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
    fetchPlayerMatches(user.userId);
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
            style: const TextStyle(
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
            : agentes.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _isSelected.length,
                          itemBuilder: (context, index) {
                            final agente = agentes[index];
                            return _buildMatchComponent(agente, index, context);
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      "¡Aun no tienes match!",
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                  ),
      ),
    );
  }

  Widget _buildMatchComponent(Agente agente, int index, BuildContext context) {
    DateTime? birthDate = agente.birthDate;

    String formattedDate =
        birthDate != null ? DateFormat('dd-MM-yyyy').format(birthDate) : '';
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
        height: _isSelected[index] ? 220 : 109,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          gradient: _isSelectedAux[index]
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 180, 64),
                    Color.fromARGB(255, 0, 225, 80),
                    Color.fromARGB(255, 0, 178, 63),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(
            _isSelected[index] ? 56 : 109,
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
                    child: CachedNetworkImage(
                      placeholder: (context, url) => AvatarPlaceholder(107),
                      errorWidget: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/fot.png',
                          fit: BoxFit.fill,
                          width: 107,
                          height: 107,
                        );
                      },
                      imageUrl: agente.imageUrl ?? '',
                      fit: BoxFit.fill,
                      width: 107,
                      height: 107,
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
                          '${agente.nombre} ${agente.apellido}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          '${agente.provincia}, ${agente.pais}',
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
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextButton(
                          onTap: () {
                            final friend = UserModel.fromAgent(agente);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
