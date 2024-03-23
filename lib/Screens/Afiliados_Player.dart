import 'dart:convert';

import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AfiliadosPlayer extends StatelessWidget {
  const AfiliadosPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF212121), Color(0xFF121212)],
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'AFILIADOS',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.transparent, // AppBar transparente
          elevation: 0, // Quitar sombra
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        extendBody: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80.0),
            CustomTextButton(
              onTap: () async {
                final playerProvider =
                    Provider.of<PlayerProvider>(context, listen: false);
                final response = await ApiClient().post(
                    'auth/create-referral-code',
                    {"userId": playerProvider.getPlayer()!.userId});
                if (response.statusCode == 200) {
                  final jsonData = jsonDecode(response.body);
                  final code = jsonData["referralCode"];
                  playerProvider.updateRefCode(code);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListaReferidosScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(
                            'Hubo un error al generar tu codigo de referido, intentalo de  nuevo.')),
                  );
                }
              },
              text: 'Generar código',
              buttonPrimary: true,
              width: 204,
              height: 39,
            ),
            const SizedBox(height: 60.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w100,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/Logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListaReferidosScreen extends StatelessWidget {
  const ListaReferidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    final player = playerProvider.getPlayer();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          children: [
            const SizedBox(height: 32.0),
            const Text(
              'Afiliados',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            SelectableText(
              'https://Ejemplo.Com/Ref?=${player!.referralCode!}',
              style: const TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: player.referralCode!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.greenAccent,
                      content: Text('Codigo de afiliado copiado.')),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: const Color(0xFF05FF00), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'TU CÓDIGO: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      player!.referralCode!,
                      style: const TextStyle(
                        color: Color(0xFF05FF00),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Personas Referidas',
              style: TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15.0),
            ...List.generate(
                3,
                (index) => const ReferidoItem(
                    email: 'Correo@gmail.com', ganancia: '00,00€')),
            const SizedBox(height: 24.0),
            const Text(
              'TOTAL:',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              '00,00€',
              style: TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 90.0),
              child: CustomTextButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RetirarMenu()),
                  );
                },
                text: 'Retirar',
                buttonPrimary: true,
                width: 100,
                height: 40,
              ),
            ),
            const SizedBox(height: 32.0),
            Align(
              alignment: Alignment.bottomCenter,
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
}

class ReferidoItem extends StatelessWidget {
  final String email;
  final String ganancia;

  const ReferidoItem({super.key, required this.email, required this.ganancia});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      width: 380,
      height: 59,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: const Color(0xFF05FF00), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            email,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 13.0,
            ),
          ),
          Text(
            ganancia,
            style: const TextStyle(
              color: Color(0xFF05FF00),
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}

class RetirarMenu extends StatelessWidget {
  const RetirarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 26.0),
          const Text(
            'Retiro',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 36.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30.0),
          const Text(
            'Total:',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 19.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const Text(
            '00,00€',
            style: TextStyle(
              color: Color(0xFF05FF00),
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 40.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          _buildTextField('Banco'),
          const SizedBox(height: 8.0),
          _buildTextField('Nombre del titular'),
          const SizedBox(height: 8.0),
          _buildTextField('Número de cuenta'),
          const SizedBox(height: 32.0),
          const SizedBox(height: 40.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: CustomTextButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RetirarMenu()),
                );
              },
              text: 'Enviar',
              buttonPrimary: true,
              width: 100,
              height: 40,
            ),
          ),
          const SizedBox(height: 102.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/Logo.png',
              width: 104,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.white, fontFamily: 'Montserrat', fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 8.0),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF05FF00)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF05FF00)),
          ),
        ),
      ),
    );
  }
}
