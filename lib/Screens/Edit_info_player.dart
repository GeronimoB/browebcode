import 'package:bro_app_to/providers/agent_provider.dart';
import 'package:bro_app_to/utils/agente_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditarInfo extends StatefulWidget {
  @override
  _EditarInfoState createState() => _EditarInfoState();
}

class _EditarInfoState extends State<EditarInfo> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _correoController;
  late TextEditingController _usuarioController;
  late TextEditingController _paisController;
  late TextEditingController _provinciaController;
  late AgenteProvider provider;
  late Agente agente;
  Future<void> _seleccionarImagen() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<AgenteProvider>(context, listen: true);
    agente = provider.getAgente();
    _nombreController = TextEditingController(text: agente.nombre);
    _apellidoController = TextEditingController(text: agente.apellido);
    _correoController = TextEditingController(text: agente.correo);
    _usuarioController = TextEditingController(text: agente.usuario);
    _paisController = TextEditingController(text: agente.pais);
    _provinciaController = TextEditingController(text: agente.provincia);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 44, 44, 44),
            Color.fromARGB(255, 0, 0, 0),
          ],
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
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _seleccionarImagen,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 118,
                      height: 118,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Nombre', _nombreController),
              _buildTextField('Apellido', _apellidoController),
              _buildTextField('Correo', _correoController),
              _buildTextField('Usuario', _usuarioController),
              _buildTextField('País', _paisController),
              _buildTextField('Provincia', _provinciaController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: const TextStyle(color: Color(0xFF00E050)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00E050)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00E050)),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Color(0xFF00E050)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
