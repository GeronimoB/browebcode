import 'package:bro_app_to/Screens/metodo_pago_screen.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

int _selectedOptionIndex = -1; // Índice de la opción seleccionada
bool _isSelected = false;

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
    nombre: 'Coaching Deportivo',
    precio: '49.99€/Mes',
    descripcion:
        'Desde Nuestra Plataforma, somo conscientes de la gran importancia que tiene la fortaleza mental de un deportista de alto nivel.',
    descripcionLarga:
        'Desde Nuestra Plataforma, somo conscientes de la gran importancia que tiene la fortaleza mental de un deportista de alto nivel. Es por ello, que el Coaching deportivo está cada vez más presente en el día a día de vida deportiva, de ahí nuestra aportación en propuesta de valor personal y deportivo a los usuarios.',
  ),
  Plan(
    nombre: 'Asesoramiento Deportivo',
    precio: '49.99€/Mes',
    descripcion:
        'Ante cualquier duda que le pueda surgir a nuestros usuarios para la toma de una determinada decisión deportiva',
    descripcionLarga:
        'Ante cualquier duda que le pueda surgir a nuestros usuarios para la toma de una determinada decisión deportiva, Nuestra plataforma cuenta con personal altamente cualificado para tal asesoramiento y ayudar a una toma de decisión acertada.',
  ),
  Plan(
    nombre: 'Representación Deportiva',
    precio: '49.99€/Mes',
    descripcion:
        'Dentro del apartado de Representación Deportiva, se informará al usuario que contamos con los mecanismo oportunos ',
    descripcionLarga:
        'Dentro del apartado de Representación Deportiva, se informará al usuario que contamos con los mecanismo oportunos y altamente cualificados para prestar los servicios a nuestros usuarios de que puedan disponer de Representación Deportiva a través de nuestra plataforma.',
  ),
  Plan(
    nombre: 'Asesoramiento Legal',
    precio: '49.99€/Mes',
    descripcion:
        'La tranquilidad y la paz deportiva es indispensable para obtener un rendimiento de éxito. ',
    descripcionLarga:
        'La tranquilidad y la paz deportiva es indispensable para obtener un rendimiento de éxito. Por ello, ofrecemos a nuestros usuarios la opción de poder obtener ayuda Legal en el caso de tener cualquier controversia contractual con algún otro.',
  ),
];

class Servicios extends StatefulWidget {
  const Servicios({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlanesPagoState createState() => _PlanesPagoState();
}

class _PlanesPagoState extends State<Servicios> {
  int _selectedCardIndex = -1; // Índice de la tarjeta seleccionada

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
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
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50), // Espacio en la parte superior
                const Text(
                  'Servicios',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: planes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCard(index);
                    },
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Seleccione una opción de pago:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              _isSelected = value!;
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color(0xff00E050);
                              }
                              return Colors.white;
                            },
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Bordes redondeados
                          ),
                        ),
                        const Text(
                          'Full Plan: Todos los servicios 149,99€/Mes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: CustomTextButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MetodoDePagoScreen(
                                    valueToPay: 50.99,
                                  )),
                        );
                      },
                      text: 'Siguiente',
                      buttonPrimary: true,
                      width: 116,
                      height: 39),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: SvgPicture.asset(
                      'assets/icons/Logo.svg',
                      width: 104,
                    ),
                  ),
                )
              ],
            ),
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
            _selectedCardIndex = -1;
          } else {
            _selectedCardIndex = index;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: const Color(0xFF00F056),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    const CustomBoxShadow(
                      color: Color.fromARGB(255, 5, 255, 80),
                      offset: Offset(0, 0),
                    ),
                  ]
                : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Logo.svg',
                  width: 62,
                  height: 32,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.nombre,
                      style: const TextStyle(
                        color: Color(0xFF00F056),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Total: ${plan.precio}',
                      style: const TextStyle(
                        color: Color(0xFF00F056),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Que Incluye:',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            if (!plan.isExpanded) ...[
              Text(
                plan.descripcion,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    fontStyle: FontStyle.italic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              InkWell(
                child: const Text(
                  'Ver más...',
                  style: TextStyle(
                      color: Color(0xFF00F056),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
                onTap: () => setState(() {
                  plan.isExpanded = true;
                }),
              ),
            ] else ...[
              Text(
                plan.descripcionLarga,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    fontStyle: FontStyle.italic),
              ),
              InkWell(
                child: const Text(
                  'Ver menos...',
                  style: TextStyle(
                      color: Color(0xFF00F056),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
                onTap: () => setState(() {
                  plan.isExpanded = false;
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
