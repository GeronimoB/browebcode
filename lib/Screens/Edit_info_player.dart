import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarInfo extends StatefulWidget {
  @override
  _EditarInfoState createState() => _EditarInfoState();
}

class _EditarInfoState extends State<EditarInfo> {
  final TextEditingController _nombreController = TextEditingController(text: 'Nombre Predeterminado');
  final TextEditingController _apellidoController = TextEditingController(text: 'Apellido Predeterminado');
  final TextEditingController _correoController = TextEditingController(text: 'Correo Predeterminado');
  final TextEditingController _usuarioController = TextEditingController(text: 'Usuario Predeterminado');
  final TextEditingController _paisController = TextEditingController(text: 'País Predeterminado');
  final TextEditingController _provinciaController = TextEditingController(text: 'Provincia Predeterminada');

  Future<void> _seleccionarImagen() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: SingleChildScrollView(
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
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
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
            readOnly: !controller.text.isNotEmpty, // Utiliza readOnly en lugar de enabled
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF00E050)),
          onPressed: () {
            setState(() {
              controller.text = "Valor predeterminado";
            });
          },
        ),
      ],
    ),
  );
}

}
