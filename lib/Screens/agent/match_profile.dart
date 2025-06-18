import 'dart:convert';

import 'package:bro_app_to/Screens/chat_page.dart';
import 'package:bro_app_to/components/avatar_placeholder.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 50) {
      setState(() {
        _appBarColor = Colors.black.withOpacity(0.9);
      });
    } else {
      setState(() {
        _appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      "friendID": "user_$userId",
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
    final double appBarHeight = AppBar(
          scrolledUnderElevation: 0,
        ).preferredSize.height *
        2.2;
    final double availableHeight =
        MediaQuery.of(context).size.height - appBarHeight;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 530),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2C2C2C), Color(0xFF000000)],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                scrolledUnderElevation: 0,
                centerTitle: true,
                backgroundColor: _appBarColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF00E050),
                    size: 32,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              extendBody: true,
              body: FutureBuilder(
                future: _fetchUserData(widget.userId),
                builder: (context, AsyncSnapshot<PlayerFullModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      translations!["ErrorLoadingUserInfo"],
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ));
                  } else {
                    final userData = snapshot.data!;
                    DateTime? birthDate = userData.birthDate;

                    String formattedDate = birthDate != null
                        ? DateFormat('dd-MM-yyyy').format(birthDate)
                        : '';

                    String? estado;
                    if (userData.pais != null && userData.provincia != null) {
                      final provincia = provincesByCountry[userData.pais]
                          ?[userData.provincia];
                      final pais = countries[userData.pais];
                      if (provincia != null && pais != null) {
                        estado = '$provincia, $pais';
                      } else if (provincia != null) {
                        estado = provincia;
                      } else if (pais != null) {
                        estado = pais;
                      }
                    }
                    String? pieDominante = userData.pieDominante != null
                        ? piesDominantes[userData.pieDominante]
                        : null;

                    String? posicion = userData.position != null
                        ? posiciones[userData.position] ?? userData.position
                        : null;

                    String? categoria = userData.categoria != null
                        ? categorias[userData.categoria]
                        : null;

                    String seleccion = '';
                    if (userData.seleccionNacional != null) {
                      final sel = selecciones[userData.seleccionNacional];
                      final catSel = (userData.categoriaSeleccion != null &&
                              nationalCategories[userData.seleccionNacional] !=
                                  null)
                          ? nationalCategories[userData.seleccionNacional]![
                              userData.categoriaSeleccion]
                          : null;

                      if (sel != null) seleccion += sel;
                      if (catSel != null) seleccion += ' $catSel';
                    }
                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(0),
                      child: SizedBox(
                        height: availableHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    AvatarPlaceholder(400 / 2),
                                errorWidget: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/fot.png',
                                    fit: BoxFit.fill,
                                    width: 400 / 2,
                                    height: 400 / 2,
                                  );
                                },
                                imageUrl: userData.userImage ?? '',
                                fit: BoxFit.fill,
                                width: 400 / 2,
                                height: 400 / 2,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${userData.name} ${userData.lastName}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                  ),
                                ),
                                if (userData.verificado)
                                  const SizedBox(
                                    width: 10,
                                  ),
                                if (userData.verificado)
                                  const Icon(
                                    Icons.verified,
                                    color: Color(0xFF00E050),
                                    size: 24,
                                  ),
                              ],
                            ),
                            if (formattedDate.isNotEmpty)
                              _buildDataRow(context,
                                  '${translations!["BirthDate"]}: $formattedDate'),
                            if (estado != null)
                              _buildDataRow(context,
                                  '${translations!["state_label"]}: $estado'),
                            if (userData.altura != null &&
                                userData.altura!.isNotEmpty)
                              _buildDataRow(context,
                                  '${translations!["height_label"]}: ${userData.altura}'),
                            if (pieDominante != null)
                              _buildDataRow(context,
                                  '${translations!["dominant_feet"]}: $pieDominante'),
                            if (posicion != null && posicion.isNotEmpty)
                              _buildDataRow(context,
                                  '${translations!["position_label"]}: $posicion'),
                            if (categoria != null && categoria.isNotEmpty)
                              _buildDataRow(context,
                                  '${translations!["Categorys"]}: $categoria'),
                            if (userData.club != null &&
                                userData.club!.isNotEmpty)
                              _buildDataRow(context,
                                  '${translations!["SportsSchool"]}: ${userData.club}'),
                            if (userData.logrosIndividuales != null &&
                                userData.logrosIndividuales!.isNotEmpty)
                              _buildDataRow(context,
                                  '${translations!["IndividualAchievements"]}: ${userData.logrosIndividuales}'),
                            if (seleccion.isNotEmpty)
                              _buildDataRow(context,
                                  '${translations!["Selections"]}: $seleccion'),
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
                                text: translations!["goToChat"],
                                buttonPrimary: false,
                                width: 154,
                                height: 40),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
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
      debugPrint(e.toString());
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
