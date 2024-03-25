import 'dart:convert';

import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:intl/intl.dart';

class MatchProfile extends StatelessWidget {
  final int userId;
  MatchProfile({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchUserData(userId),
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
            return Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Image.asset(
                            'assets/images/jugador1.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SafeArea(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Color(0xFF05FF00)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                    _buildDataRow(context, formattedDate),
                    _buildDataRow(
                        context, '${userData.provincia}, ${userData.pais}'),
                    _buildDataRow(context, '${userData.categoria}'),
                    _buildDataRow(context, '${userData.club}'),
                    _buildDataRow(context, '${userData.logrosIndividuales}'),
                    _buildDataRow(context,
                        '${userData.seleccionNacional} ${userData.categoriaSeleccion}'),
                    const SizedBox(height: 20),
                    CustomTextButton(
                      onTap: () {},
                      text: '¡Vamos al Chat!',
                      buttonPrimary: false,
                      width: 154,
                      height: 39,
                    ),
                  ],
                ),
              ),
            );
          }
        },
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
