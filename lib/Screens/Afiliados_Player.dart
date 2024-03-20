import 'package:flutter/material.dart';

class AfiliadosPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          GenerarCodigoScreen(),
          ListaReferidosScreen(),
          RetiroFondosScreen(),
        ],
      ),
    );
  }
}

class GenerarCodigoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Usar el mismo estilo de fondo que las otras pantallas
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // Implementar generación de código
            },
            child: Text('Generar Código'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF05FF00), // Color del botón
            ),
          ),
          const Text(
            'Lorem ipsum dolor sit amet...',
            // Estilo del texto
          ),
          // Agregar el resto de los elementos de la UI
        ],
      ),
    );
  }
}

class ListaReferidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Usar el mismo estilo de fondo que las otras pantallas
      padding: EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

        ],
      ),
    );
  }
}

class RetiroFondosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF05FF00), 
            ),
            child: const Text('Enviar'),
          ),

        ],
      ),
    );
  }
}
