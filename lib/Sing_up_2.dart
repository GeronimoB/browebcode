import 'package:flutter/material.dart';
import 'package:bro_app_to/Sing_up_3.dart';
import 'package:flutter_svg/svg.dart';


class Plan {
  String nombre;
  String precio;
  String descripcion;
  String descripcionLarga;
  bool isExpanded;

  Plan({
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.descripcionLarga,
    this.isExpanded = false,
  });
}


List<Plan> planes = [
  Plan(
    nombre: 'Basic',
    precio: '19,99€',
    descripcion: 'Posibilita subir 2 videos de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD.',
    descripcionLarga: 'Suscripcion Basic: PVP 19,99€. Tiempo de vigencia un mes. Posibilita subir 2 videos (3 videos) de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD. Sube nuevo video una vez tengas el cupo de 2 cubierto, para ello deberás eliminar uno de la plataforma para que sea efectiva la subida, y seguir manteniendo tus 2 videos (3 videos) activos. Destaca tu video: PVP 2,99€ por video (Recomendación 0,99€ por video).',
  ),
    Plan(
    nombre: 'Gold',
    precio: '29,99€',
    descripcion: 'Posibilita subir 5 videos de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD.',
    descripcionLarga: 'ube nuevo video una vez tengas el cupo de 5 cubierto, para ello deberás eliminar uno de la plataforma para que sea efectiva la subida y seguir manteniendo tus 5 videos activos..',
  ),
    Plan(
    nombre: 'Platinum',
    precio: '49,99€ ',
    descripcion: 'Posibilita subir 10 videos de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD.',
    descripcionLarga: 'Sube nuevo video una vez tengas el cupo de 10 cubiertos, para ellos deberás eliminar uno de la plataforma para que sea efectiva la subida y seguir  manteniendo tus 10 videos activos',
  ),
    Plan(
    nombre: 'Unlimited',
    precio: '89,99€',
    descripcion: 'Dicha suscripción tiene una duración de 12 meses, y posibilita subir videos ilimitados con un máximo de 2min',
    descripcionLarga: 'Dicha suscripción tiene una duración de 12 meses, y posibilita subir videos ilimitados con un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD',
  ),
];

class SignUpScreen_2 extends StatefulWidget {
  @override
  _SignUpScreen_2State createState() => _SignUpScreen_2State();
}

class _SignUpScreen_2State extends State<SignUpScreen_2> {
  int _selectedCardIndex = -1; // Índice de la tarjeta seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundplanes.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50), // Espacio en la parte superior
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Text(
                  'Planes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: planes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCard(index);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen_3()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFF00F056),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 104,
                ),
              ),
            ],
          ),
        ],
      ),
    );
 }

 Widget _buildCard(int index) {
  Plan plan = planes[index];

  bool isSelected = _selectedCardIndex == index;

  return GestureDetector(
    onTap: () {
      setState(() {
        if (isSelected) {
          _selectedCardIndex = -1; // Deseleccionar
        } else {
          _selectedCardIndex = index; // Seleccionar la tarjeta
        }
      });
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: isSelected ? Colors.lightGreen : const Color(0xFF00F056), // Cambiar el color del borde si está seleccionado
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/Logo.png',
                width: 62,
                height: 32,
              ),
              const SizedBox(width: 10),
              Text(
                plan.nombre,
                style: const TextStyle(color: Color(0xFF00F056), fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const Spacer(),
              Text(
                'Total: ${plan.precio}',
                style: const TextStyle(color: Color(0xFF00F056), fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Que Incluye:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
if (!plan.isExpanded) ...[
            Text(
              plan.descripcion,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            InkWell(
              child: const Text(
                'Ver más...',
                style: TextStyle(color: Color(0xFF00F056), fontSize: 11),
              ),
              onTap: () => setState(() {
                plan.isExpanded = true; // Cambiamos el estado a expandido
              }),
            ),
          ] else ...[ // Aquí se agrega el caso contrario, cuando isExpanded es true
            Text(
              plan.descripcionLarga,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            InkWell(
              child: const Text(
                'Ver menos...',
                style: TextStyle(color: Color(0xFF00F056), fontSize: 11),
              ),
              onTap: () => setState(() {
                plan.isExpanded = false; // Aquí cambiamos el estado a no expandido
              }),
            ),
          ],
        ],
      ),
    ),
  );
}

}