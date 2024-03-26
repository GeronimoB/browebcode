import 'package:bro_app_to/Screens/afiliados_player.dart';
import 'package:bro_app_to/Screens/player/cuenta_player.dart';
import 'package:bro_app_to/Screens/notificaciones.dart';
import 'package:bro_app_to/Screens/player/edit_player_info.dart';
import 'package:bro_app_to/Screens/player/pedidos.dart';
import 'package:bro_app_to/Screens/privacidad.dart';
import 'package:bro_app_to/Screens/player/servicios.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/presentation/screens/Sing_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bro_app_to/providers/player_provider.dart';

import 'bottom_navigation_bar_player.dart';

class ConfigProfilePlayer extends StatelessWidget {
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
            SizedBox(height: 22),
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
                    CustomBottomNavigationBarPlayer(initialIndex: 4)),
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
                  _buildListItem('CUENTA', context, true, CuentaPage()),
                  _buildListItem(
                      'EDITAR INFORMACION', context, true, EditarInfoPlayer()),
                  _buildListItem('PRIVACIDAD', context, true, Privacidad()),
                  const SizedBox(height: 15),
                  _buildListItem('CENTRO DE AYUDA (FAQ)', context, false,
                      ConfigProfilePlayer()),
                  _buildListItem(
                      'SOPORTE', context, false, ConfigProfilePlayer()),
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
                  const SizedBox(height: 15),
                  _buildListItem(
                      'CERRAR SESIÓN', context, false, const Servicios(),
                      callback: () {
                    handleLogOut(context);
                  }),
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

  void handleLogOut(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xff3B3B3B),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(5, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "¿Esta seguro de que desea cerrar sesión?",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextButton(
                      onTap: () => Navigator.of(context).pop(),
                      text: 'Cancelar',
                      buttonPrimary: false,
                      width: 90,
                      height: 35,
                    ),
                    CustomTextButton(
                      onTap: () {
                        final playerProvider =
                            Provider.of<PlayerProvider>(context, listen: false);
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);

                        playerProvider.logOut();
                        userProvider.logOut();

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                      text: 'Continuar',
                      buttonPrimary: true,
                      width: 90,
                      height: 35,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xff3B3B3B),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(5, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "¿Esta seguro de que desea borrar la cuenta? Se borraran todos los datos asociados.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextButton(
                      onTap: () => Navigator.of(context).pop(),
                      text: 'Cancelar',
                      buttonPrimary: false,
                      width: 90,
                      height: 35,
                    ),
                    CustomTextButton(
                      onTap: () {
                        final playerProvider =
                            Provider.of<PlayerProvider>(context, listen: false);
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);

                        playerProvider.logOut();
                        userProvider.logOut();

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/intro', (route) => false);
                      },
                      text: 'Continuar',
                      buttonPrimary: true,
                      width: 90,
                      height: 35,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(
      String title, BuildContext context, bool showTrailingIcon, Widget page,
      {Function? callback}) {
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
        if (callback != null) {
          callback.call();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }
}
