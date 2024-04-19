import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/components/app_bar_title.dart';

class RetirarMenu extends StatelessWidget {
  const RetirarMenu({super.key});

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
        extendBody: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: appBarTitle('RETIRO'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E050),
              size: 32,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Total:',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 19.0,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              '00,00€',
              style: const TextStyle(
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
              child: const CustomTextButton(
                onTap: null,
                text: 'Enviar',
                buttonPrimary: true,
                width: 100,
                height: 40,
              ),
            ),
            const SizedBox(height: 102.0),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 104,
                ),
              ),
            ),
          ],
        ),
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
              color: Colors.white, fontFamily: 'Montserrat', fontSize: 16),
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
