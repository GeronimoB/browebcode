import 'dart:convert';

import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/components/custom_text_button.dart';

class MatchProfile extends StatelessWidget {
  final int userId;
  MatchProfile({required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF05FF00)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: _fetchUserData(userId),
        builder: (context, AsyncSnapshot<PlayerFullModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green), // Color del loader
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar la información del usuario'));
          } else {
            final userData = snapshot.data!;

            return Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.asset(
                        'assets/images/jugador1.png', // Ruta de la imagen local
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${userData.name} ${userData.lastName}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white), // Texto en blanco
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(context, 'Fecha de Nacimiento:',
                        '${userData.birthDate}'),
                    _buildInfoRow(context, 'País, Provincia:',
                        '${userData.pais}, ${userData.provincia}'),
                    _buildInfoRow(
                        context, 'Categoría:', '${userData.categoria}'),
                    _buildInfoRow(
                        context, 'Escuela Deportiva:', '${userData.club}'),
                    _buildInfoRow(context, 'Logros Individuales:',
                        '${userData.logrosIndividuales}'),
                    _buildInfoRow(context, 'Selección Nacional:',
                        '${userData.seleccionNacional} ${userData.categoriaSeleccion}'),
                    SizedBox(height: 20),
                    CustomTextButton(
                      onTap: () {},
                      text: '¡Vamos al Chat!',
                      buttonPrimary: true,
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white), // Texto en blanco
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14, color: Colors.white), // Texto en blanco
          ),
        ],
      ),
    );
  }
}
