import 'package:bro_app_to/Screens/afiliados_player.dart';
import 'package:bro_app_to/Screens/agent/edit_agent_info.dart';
import 'package:bro_app_to/Screens/notificaciones.dart';
import 'package:bro_app_to/Screens/player/pedidos.dart';
import 'package:bro_app_to/Screens/privacidad.dart';
import 'package:bro_app_to/Screens/player/servicios.dart';
import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../providers/agent_provider.dart';
import '../../providers/user_provider.dart';

class ConfigProfile extends StatefulWidget {
  const ConfigProfile({super.key});

  @override
  State<ConfigProfile> createState() => _ConfigProfileState();
}

class _ConfigProfileState extends State<ConfigProfile> {
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
                      'EDITAR INFORMACION', context, true, EditarInfo(), true),
                  _buildListItem(
                      'PRIVACIDAD', context, true, Privacidad(), true),
                  const SizedBox(height: 15),
                  _buildListItem('CENTRO DE AYUDA (FAQ)', context, false,
                      ConfigProfile(), false),
                  _buildListItem(
                      'SOPORTE', context, false, ConfigProfile(), false),
                  _buildListItem(
                      'NOTIFICACIONES', context, true, Notificaciones(), true),
                  _buildListItem(
                      'AFILIADOS',
                      context,
                      true,
                      user.referralCode != ""
                          ? const ListaReferidosScreen()
                          : const AfiliadosPlayer(),
                      true),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 32.0),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/Logo.svg',
                width: 104,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, BuildContext context,
      bool showTrailingIcon, Widget? page, bool goToNewPage) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: goToNewPage ? FontWeight.w500 : FontWeight.bold,
        ),
      ),
      trailing: showTrailingIcon
          ? const Icon(Icons.chevron_right, color: Color(0xFF05FF00))
          : null,
      onTap: () {
        if (goToNewPage) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page!),
          );
        }
      },
    );
  }
}
