import 'dart:convert';
import 'dart:io';

import 'package:bro_app_to/components/app_bar_title.dart';

import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_constants.dart';
import '../../utils/current_state.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  late PlayerProvider provider;
  late PlayerFullModel player;
  final picker = ImagePicker();
  bool isLoading = false;
  Map<String, dynamic> files = {
    "dni_frontal": null,
    "dni_trasero": null,
    "selfie": null,
  };
  Map<String, String> fileName = {
    "dni_frontal": "Sin archivo seleccionado.",
    "dni_trasero": "Sin archivo seleccionado.",
    "selfie": "Sin archivo seleccionado.",
  };
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<PlayerProvider>(context, listen: true);
    player = provider.getPlayer()!;
  }

  Future<void> _openGallery(String camp) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        files[camp] = pickedFile.path;
        fileName[camp] = pickedFile.name;
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  void _uploadFiles() async {
    try {
      setState(() {
        isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final usuario = userProvider.getCurrentUser();
      const url = '${ApiConstants.baseUrl}/auth/upload-verification-files';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      for (String camp in files.keys) {
        String? filePath = files[camp];
        if (filePath != null) {
          request.files.add(await http.MultipartFile.fromPath(camp, filePath));
        } else {
          showErrorSnackBar(context, "Por favor, Sube todos los archivos");
          return;
        }
      }
      request.fields["userId"] = usuario.userId.toString();
      request.fields["isAgent"] = "false";
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        final msg = jsonDecode(responseBody)["mssg"];
        setState(() {
          isLoading = false;
        });
        showSucessSnackBar(context, msg);
        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pushReplacementNamed('/config-player');
      } else {
        setState(() {
          isLoading = false;
        });
        showErrorSnackBar(context, "Ha ocurrido un error, intentelo de nuevo.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorSnackBar(context, "Ha ocurrido un error, intentelo de nuevo.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/config-player');
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF444444), Color(0xFF000000)],
          ),
        ),
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0,
                centerTitle: true,
                title: appBarTitle('VERIFICACIÓN'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF00E050),
                    size: 32,
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed('/config-player'),
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  _buildTextField(label: 'DNI FRONTAL', camp: 'dni_frontal'),
                  _buildTextField(label: 'DNI TRASERO', camp: 'dni_trasero'),
                  _buildTextField(label: 'SELFIE', camp: 'selfie'),
                  const SizedBox(height: 35),
                  CustomTextButton(
                    text: 'Subir',
                    buttonPrimary: true,
                    width: 150,
                    height: 45,
                    onTap: _uploadFiles,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/images/Logo.png',
                        width: 104,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isLoading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String camp,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              fileName[camp] ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF00E050)),
            onPressed: () {
              _openGallery(camp);

              //obtener el
            },
          ),
        ],
      ),
    );
  }
}