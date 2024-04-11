import 'dart:convert';

import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'lista_afiliados.dart';

class AfiliadosPlayer extends StatelessWidget {
  const AfiliadosPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          centerTitle: true,
          title: const Text(
            'AFILIADOS',
            style: const TextStyle(
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
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E050),
              size: 32,
            ),
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
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);

                final response = await ApiClient().post(
                    'auth/create-referral-code', {
                  "userId": userProvider.getCurrentUser().userId.toString()
                });
                if (response.statusCode == 200) {
                  final jsonData = jsonDecode(response.body);
                  final code = jsonData["referralCode"];
                  userProvider.updateRefCode(code);

                  Navigator.of(context).pushReplacement(
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
                style: const TextStyle(
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
