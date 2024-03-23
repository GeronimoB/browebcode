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
              onTap: _seleccionarImagen,
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 59,
                child: const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt,
                    color: Color(0xFF00E050),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(label: 'NOMBRE', controller: _nombreController),
            _buildTextField(label: 'APELLIDO', controller: _apellidoController),
            _buildTextField(label: 'CORREO', controller: _correoController),
            _buildTextField(label: 'USUARIO', controller: _usuarioController),
            _buildTextField(label: 'PAÍS', controller: _paisController),
            _buildTextField(label: 'PROVINCIA', controller: _provinciaController),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextField({required String label, required TextEditingController controller}) {
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
void _editarCampo(BuildContext context, String label, TextEditingController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController editingController = TextEditingController(text: controller.text);
      return AlertDialog(
        backgroundColor: Colors.grey[800], 
        title: Text(
          'Editar $label',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        content: TextField(
          controller: editingController,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white, 
          ),
          decoration: InputDecoration(
            hintText: 'Introduce tu $label',
            hintStyle: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white54, 
            ),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), 
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green), 
            ),
          ),
          cursorColor: Colors.white, 
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white, 
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Guardar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white, 
              ),
            ),
            onPressed: () {
              if (mounted) {
                setState(() {
                  controller.text = editingController.text;
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}