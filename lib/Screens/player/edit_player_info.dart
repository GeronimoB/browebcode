import 'dart:convert';
import 'dart:io';

import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_constants.dart';

class EditarInfoPlayer extends StatefulWidget {
  @override
  _EditarInfoPlayerState createState() => _EditarInfoPlayerState();
}

class _EditarInfoPlayerState extends State<EditarInfoPlayer> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _correoController;
  late TextEditingController _paisController;
  late TextEditingController _provinciaController;
  late TextEditingController _posicionController;
  late TextEditingController _categoriaController;
  late TextEditingController _logrosIndividualesController;
  late TextEditingController _AlturaController;
  late TextEditingController _pieDominanteController;
  late TextEditingController _seleccionNacionalController;

  late PlayerProvider provider;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    final player = playerProvider.getPlayer()!;
    _nombreController = TextEditingController(text: player.name);
    _apellidoController = TextEditingController(text: player.lastName);
    _correoController = TextEditingController(text: player.email);
    _paisController = TextEditingController(text: player.pais);
    _provinciaController = TextEditingController(text: player.provincia);
    _posicionController = TextEditingController(text: player.position);
    _categoriaController = TextEditingController(text: player.categoria);
    _logrosIndividualesController =
        TextEditingController(text: player.logrosIndividuales);
    _AlturaController = TextEditingController(text: player.altura);
    _pieDominanteController = TextEditingController(text: player.pieDominante);
    _seleccionNacionalController =
        TextEditingController(text: player.seleccionNacional);
  }

  Future<void> _openGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final agenteProvider = Provider.of<PlayerProvider>(context, listen: false);
    final usuario = userProvider.getCurrentUser();
    const url = '${ApiConstants.baseUrl}/auth/upload-player-image';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files
        .add(await http.MultipartFile.fromPath('imagen', imageFile.path));
    request.fields["userId"] = usuario.userId.toString();
    request.fields["isAgent"] = "true";
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      final image = jsonDecode(responseBody)["image"];
      agenteProvider.updateLocalImage(image);
      userProvider.updateLocalImage(image);
    } else {
      print('Failed to upload image. Error code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.getCurrentUser();
    print("imagen: ${user.imageUrl}");
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF212121), Color(0xFF121212)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'EDITAR INFORMACIÓN',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E050),
              size: 32,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _openGallery,
                child: Stack(
                  children: [
                    ClipOval(
                      child: user.imageUrl != ''
                          ? ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.grey.withOpacity(0.5),
                                BlendMode.dstATop,
                              ),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/fot.png',
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  print("hubo error");
                                  return Image.asset(
                                    'assets/images/fot.png',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  );
                                },
                                image: user.imageUrl ?? '',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.grey.withOpacity(0.5),
                                BlendMode.dstATop,
                              ),
                              child: Image.asset(
                                'assets/images/fot.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const Positioned(
                      bottom: 0,
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(label: 'NOMBRE', controller: _nombreController),
              _buildTextField(
                  label: 'APELLIDO', controller: _apellidoController),
              _buildTextField(label: 'CORREO', controller: _correoController),
              _buildTextField(label: 'PAÍS', controller: _paisController),
              _buildTextField(
                  label: 'PROVINCIA', controller: _provinciaController),
              _buildTextField(
                  label: 'POSICIÓN', controller: _posicionController),
              _buildTextField(
                  label: 'CATEGORÍA', controller: _categoriaController),
              _buildTextField(
                  label: 'LOGROS', controller: _logrosIndividualesController),
              _buildTextField(label: 'ALTURA', controller: _AlturaController),
              _buildTextField(
                  label: 'PIE DOMINANTE', controller: _pieDominanteController),
              _buildTextField(
                  label: 'SELECCION', controller: _seleccionNacionalController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label, required TextEditingController controller}) {
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
              controller.text,
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
            onPressed: () => _editarCampo(context, label, controller),
          ),
        ],
      ),
    );
  }

  void _editarCampo(
      BuildContext context, String label, TextEditingController controller) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) {
        TextEditingController editingController =
            TextEditingController(text: controller.text);
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
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xff00E050),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextField(
                  controller: editingController,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                  ),
                  cursorColor: Colors.white,
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
                      height: 27,
                    ),
                    CustomTextButton(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            controller.text = editingController.text;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      text: 'Guardar',
                      buttonPrimary: true,
                      width: 90,
                      height: 27,
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
}
