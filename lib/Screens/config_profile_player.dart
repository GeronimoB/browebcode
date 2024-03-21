import 'package:bro_app_to/Screens/Afiliados_Player.dart';
import 'package:bro_app_to/Screens/CuentaPlayer.dart';
import 'package:bro_app_to/Screens/Notificaciones.dart';
import 'package:bro_app_to/Screens/Pedidos.dart';
import 'package:bro_app_to/Screens/Privacidad.dart';
import 'package:bro_app_to/Screens/Servicios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';


class ConfigProfilePlayer extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final player = playerProvider.getPlayer()!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(height: 22),
            Text(
              '${player.name} ${player.lastName}',
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
          onPressed: () => Navigator.of(context).pop(),
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
                  SizedBox(height: 22),
                    _buildListItem('CUENTA', context, true, CuentaPage()),
                    _buildListItem('PRIVACIDAD', context, true, Privacidad()),
                    SizedBox(height: 15),
                    _buildListItem('CENTRO DE AYUDA (FAQ)', context, false, ConfigProfilePlayer()),
                    _buildListItem('SOPORTE', context, false, ConfigProfilePlayer()),
                    _buildListItem('NOTIFICACIONES', context, true, Notificaciones()),
                    _buildListItem('AFILIADOS', context, true, const AfiliadosPlayer()),
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
