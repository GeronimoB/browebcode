import 'dart:convert';

import 'package:bro_app_to/Screens/agent/user_profile_to_agent.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:bro_app_to/providers/agent_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'config_profile.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late UserProvider provider;
  late UserModel user;
  final List<PlayerFullModel> players = [];
  bool isLoading = false;

  Future<void> fetchAgentMatches(String currentUserId) async {
    setState(() {
      isLoading = true;
    });
    final List<PlayerFullModel> playersAux = [];
    try {
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
      players.clear();
      players.addAll(playersAux);

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
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<AgenteProvider>(context, listen: true);
    final agente = provider.getAgente();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[850]!, Colors.black],
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Center(
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/fot.png',
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/fot.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.fill,
                        );
                      },
                      image: agente.imageUrl!,
                      width: 160,
                      height: 160,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFF00E050)),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        '/config-agent',
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${agente.nombre} ${agente.apellido}',
              style: const TextStyle(
                color: Color(0xff05FF00),
                fontWeight: FontWeight.w900,
                fontSize: 24.0,
              ),
            ),
            Text(
              '${agente.provincia}, ${agente.pais}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 70),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return jugadorCard(screenWidth, player);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget jugadorCard(double screenWidth, PlayerFullModel player) {
    DateTime? birthDate = player.birthDate;

    String formattedDate =
        birthDate != null ? DateFormat('yyyy-MM-dd').format(birthDate) : '';
    return Container(
      height: 160.0,
      margin:
          EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: const Color(0xff00F056), width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/fot.png',
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/fot.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
              image: player.userImage!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${player.name} ${player.lastName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$formattedDate ',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${player.position}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerProfileToAgent(
                        player: player,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Ver Perfil...',
                    style: TextStyle(
                        color: Color(0xff00E050),
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 2.0,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
