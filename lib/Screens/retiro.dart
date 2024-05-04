import 'package:bro_app_to/Screens/lista_afiliados.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/components/i_field.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/components/app_bar_title.dart';
import 'dart:io' as io;
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../components/upload_invoice_widthdrawl.dart';
import '../providers/user_provider.dart';
import '../utils/api_constants.dart';

class RetirarMenu extends StatefulWidget {
  final double total;
  const RetirarMenu({required this.total, super.key});

  @override
  State<RetirarMenu> createState() => _RetirarMenuState();
}

class _RetirarMenuState extends State<RetirarMenu> {
  late TextEditingController banco;
  late TextEditingController titular;
  late TextEditingController nroCuenta;

  @override
  void initState() {
    super.initState();
    banco = TextEditingController();
    titular = TextEditingController();
    nroCuenta = TextEditingController();
  }

  @override
  void dispose() {
    banco.dispose();
    titular.dispose();
    nroCuenta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ListaReferidosScreen()),
        );
        return false;
      },
      child: Container(
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
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const ListaReferidosScreen()),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
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
                Text(
                  '${widget.total} €',
                  style: const TextStyle(
                    color: Color(0xFF05FF00),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                iField(banco, 'Banco'),
                const SizedBox(height: 8.0),
                iField(titular, 'Nombre del titular'),
                const SizedBox(height: 8.0),
                iField(nroCuenta, 'Número de cuenta'),
                const SizedBox(height: 80.0),
                CustomTextButton(
                  onTap: () {
                    if (banco.text.isEmpty ||
                        titular.text.isEmpty ||
                        nroCuenta.text.isEmpty) {
                      showErrorSnackBar(
                          context, translations!['complete_all_fields']);
                      return;
                    }

                    showUploadInvoice(context, banco.text, titular.text,
                        nroCuenta.text, widget.total);
                  },
                  text: 'Retirar',
                  buttonPrimary: true,
                  width: 100,
                  height: 40,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
        ),
      ),
    );
  }
}
