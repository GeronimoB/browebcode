import 'package:bro_app_to/Screens/Afiliados_Player.dart';
import 'package:flutter/material.dart';

class ConfigProfilePlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          children: [
            SizedBox(height: 22),
            Text(
              'NOMBRE Y APELLIDO',
              style: TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
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
                  _buildListItem('CUENTA', context, true),
                  _buildListItem('PRIVACIDAD', context, true),
                  SizedBox(height: 15),
                  _buildListItem('CENTRO DE AYUDA (FAQ)', context, false),
                  _buildListItem('SOPORTE', context, false),
                  _buildListItem('NOTIFICACIONES', context, true),
                  _buildListItem('AFILIADOS', context, true),
                  _buildListItem('PEDIDOS', context, true),
                  _buildListItem('SERVICIOS', context, true),
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
      String title, BuildContext context, bool showTrailingIcon) {
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
        if (title == 'AFILIADOS') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AfiliadosPlayer()),
          );
        } else {
          // Manejar otras opciones de la lista aquí.
        }
      },
    );
  }
}
