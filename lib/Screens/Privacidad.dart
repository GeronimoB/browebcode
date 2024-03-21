import 'package:flutter/material.dart';


class Privacidad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff00E050)),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            const Text(
              'PRIVACIDAD',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: const Text(
                'Cuenta Privada',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: true,
                onChanged: (bool newValue) {},
                activeColor: Color(0xff00E050),
              ),
            ),
            InkWell(
              onTap: () {
                // Agrega la lógica para cambiar la contraseña
              },
              child: const ListTile(
                title: Text(
                  'Cambiar Contraseña',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Color(0xff00E050)),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text(
                'Autenticación de Doble Factor',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'google_authenticator') {
                }
              },
              offset: const Offset(0, 50), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), 
              ),
              color: const Color(0xff3B3B3B), 
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'google_authenticator',
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.transparent,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Google Authenticator',
                        style: TextStyle(
                          color: Color(0xff00E050), 
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              icon: const Icon(Icons.chevron_right, color: Color(0xff00E050)),
            ),

              ),
              const SizedBox(height: 10),
            
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 104,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
