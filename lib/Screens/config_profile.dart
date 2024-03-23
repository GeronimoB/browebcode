import 'package:bro_app_to/Screens/Afiliados_Player.dart';
import 'package:bro_app_to/Screens/Edit_info_player.dart';
import 'package:bro_app_to/Screens/Notificaciones.dart';
import 'package:bro_app_to/Screens/Pedidos.dart';
import 'package:bro_app_to/Screens/Privacidad.dart';
import 'package:bro_app_to/Screens/Servicios.dart';
import 'package:bro_app_to/Screens/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/agent_provider.dart';
import '../providers/user_provider.dart';

class ConfigProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getCurrentUser();
    print("este es el codigo, ${user.referralCode}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 22),
            Text(
              '${user.name} ${user.lastName}',
              style: const TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const Text(
              'CONFIGURACIÓN',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF05FF00)),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CustomBottomNavigationBar(initialIndex: 3)),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 22),
                  _buildListItem(
                      'EDITAR INFORMACION', context, true, EditarInfo()),
                  _buildListItem('PRIVACIDAD', context, true, Privacidad()),
                  const SizedBox(height: 15),
                  _buildListItem(
                      'CENTRO DE AYUDA (FAQ)', context, false, ConfigProfile()),
                  _buildListItem('SOPORTE', context, false, ConfigProfile()),
                  _buildListItem(
                      'NOTIFICACIONES', context, true, Notificaciones()),
                  _buildListItem(
                    'AFILIADOS',
                    context,
                    true,
                    user.referralCode != ""
                        ? const ListaReferidosScreen()
                        : const AfiliadosPlayer(),
                  ),
                  _buildListItem('PEDIDOS', context, true, Pedidos()),
                  _buildListItem('SERVICIOS', context, true, const Servicios()),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 32.0),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/Logo.png',
                width: 104,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      String title, BuildContext context, bool showTrailingIcon, Widget page) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: showTrailingIcon
          ? const Icon(Icons.chevron_right, color: Color(0xFF05FF00))
          : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
