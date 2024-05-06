import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'metodo_pago_screen.dart';
import '../providers/player_provider.dart';
import '../utils/plan_model.dart';

List<Plan> planes = [
  Plan(
    idPlan: 'price_1OwbK8IkdX2ffauu5v0rezbw',
    nombre: 'Basic',
    precio: '19,99',
    descripcion:
        'Posibilita subir 2 videos de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD.',
    descripcionLarga:
        'Suscripcion Basic: PVP 19,99€. Tiempo de vigencia un mes. Posibilita subir 2 videos (3 videos) de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD. Sube nuevo video una vez tengas el cupo de 2 cubierto, para ello deberás eliminar uno de la plataforma para que sea efectiva la subida, y seguir manteniendo tus 2 videos (3 videos) activos. Destaca tu video: PVP 2,99€ por video (Recomendación 0,99€ por video).',
    cualidades: [
      {"text": "Sube hasta 2 vídeos", "included": true},
      {"text": "Videos de hasta 2 minutos", "included": true},
      {
        "text": "Visualizacíon: ",
        "included": true,
        "isVisualizacion": true,
        "visualizacion": "Baja",
        "color": 0xfff23325
      },
      {"text": "Verificación de perfil opcional", "included": false},
      {"text": "Destacado de vídeos opcional", "included": false},
      {"text": "Tiempo de vigencia de 1 mes", "included": true},
    ],
  ),
  Plan(
    nombre: 'Gold',
    idPlan: 'price_1OwceiIkdX2ffauuyNaKIHHL',
    precio: '29,99',
    descripcion:
        'Posibilita subir 5 videos de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD.',
    descripcionLarga:
        'Sube nuevo video una vez tengas el cupo de 5 cubierto, para ello deberás eliminar uno de la plataforma para que sea efectiva la subida y seguir manteniendo tus 5 videos activos..',
    cualidades: [
      {"text": "Sube hasta 5 vídeos", "included": true},
      {"text": "Videos de hasta 2 minutos", "included": true},
      {
        "text": "Visualizacíon: ",
        "included": true,
        "isVisualizacion": true,
        "visualizacion": "Media",
        "color": 0xfff2c925
      },
      {"text": "Verificación de perfil opcional", "included": false},
      {"text": "Destacado de vídeos opcional", "included": false},
      {"text": "Tiempo de vigencia de 3 meses", "included": true},
    ],
  ),
  Plan(
    idPlan: 'price_1Owcf5IkdX2ffauudm4v0KAQ',
    nombre: 'Platinum',
    precio: '49,99',
    descripcion:
        'Posibilita subir 10 videos de un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD.',
    descripcionLarga:
        'Sube nuevo video una vez tengas el cupo de 10 cubiertos, para ellos deberás eliminar uno de la plataforma para que sea efectiva la subida y seguir  manteniendo tus 10 videos activos',
    cualidades: [
      {"text": "Sube hasta 10 vídeos", "included": true},
      {"text": "Videos de hasta 2 minutos", "included": true},
      {
        "text": "Visualizacíon: ",
        "included": true,
        "isVisualizacion": true,
        "visualizacion": "Alta",
        "color": 0xffd1eb6c
      },
      {"text": "Verificación de perfil opcional", "included": false},
      {"text": "Destacado de vídeos opcional", "included": false},
      {"text": "Tiempo de vigencia de 6 meses", "included": true},
    ],
  ),
  Plan(
    idPlan: 'price_1OwcfMIkdX2ffauuEqdLsX5h',
    nombre: 'Unlimited',
    precio: '89,99',
    descripcion:
        'Dicha suscripción tiene una duración de 12 meses, y posibilita subir videos ilimitados con un máximo de 2min',
    descripcionLarga:
        'Dicha suscripción tiene una duración de 12 meses, y posibilita subir videos ilimitados con un máximo de 2min cada uno de ellos, con una calidad recomendada de 1080 Full HD',
    cualidades: [
      {"text": "Sube hasta 25 vídeos", "included": true},
      {"text": "Videos de hasta 2 minutos", "included": true},
      {
        "text": "Visualizacíon: ",
        "included": true,
        "isVisualizacion": true,
        "visualizacion": "Máxima",
        "color": 0xff05FF00
      },
      {"text": "Verificación de perfil opcional", "included": true},
      {"text": "Destacado de vídeos opcional(1)", "included": true},
      {"text": "Tiempo de vigencia de 12 meses", "included": true},
    ],
  ),
];

class PlanesPago extends StatefulWidget {
  const PlanesPago({super.key});

  @override
  PlanesPagoState createState() => PlanesPagoState();
}

class PlanesPagoState extends State<PlanesPago> {
  int _selectedCardIndex = -1; // Índice de la tarjeta seleccionada

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgroundplanes.png'),
          fit: BoxFit.cover,
        ),
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: appBarTitle(translations!["PLANS"]),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: planes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCard(index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: CustomTextButton(
                  onTap: () {
                    final playerProvider =
                        Provider.of<PlayerProvider>(context, listen: false);
                    final precio = playerProvider
                        .getActualPlan()!
                        .precio
                        .replaceAll(',', '.');
                    final precioDouble = double.parse(precio);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MetodoDePagoScreen(
                                valueToPay: precioDouble,
                              )),
                    );
                  },
                  text: 'Siguiente',
                  buttonPrimary: true,
                  width: 116,
                  height: 39,
                ),
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
      ),
    );
  }

  Widget _buildCard(int index) {
    Plan plan = planes[index];

    bool isSelected = _selectedCardIndex == index;

    return GestureDetector(
      onTap: () {
        final playerProvider =
            Provider.of<PlayerProvider>(context, listen: false);
        playerProvider.selectPlan(plan);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Logo.svg',
                  width: 62,
                  height: 32,
                ),
                const SizedBox(width: 10),
                Text(
                  plan.nombre,
                  style: const TextStyle(
                      color: Color(0xFF00F056),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const Spacer(),
                Text(
                  'Total: ${plan.precio}€',
                  style: const TextStyle(
                      color: Color(0xFF00F056),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Qué incluye:',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!plan.isExpanded) ...[
              ...plan.cualidades
                  .map((cualidad) => cualidades(cualidad))
                  .toList()
                  .take(2),
              InkWell(
                child: const Text(
                  'Ver más...',
                  style: const TextStyle(
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
              ...plan.cualidades
                  .map((cualidad) => cualidades(cualidad))
                  .toList(),
              InkWell(
                child: const Text(
                  'Ver menos...',
                  style: const TextStyle(
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

  Widget cualidades(Map<String, dynamic> cualidad) {
    bool included = cualidad["included"];
    String text = cualidad["text"];
    String visualizacion = cualidad["visualizacion"] ?? '';
    int color = cualidad["color"] ?? 0;
    bool isVisualizacion = cualidad["isVisualizacion"] ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          included ? Icons.check : Icons.cancel,
          size: 24,
          color: included
              ? const Color(0xFF05FF00)
              : const Color.fromARGB(255, 242, 51, 37),
        ),
        const SizedBox(
          width: 5,
        ),
        Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              maxLines: 1,
            ),
          ),
        ),
        if (isVisualizacion)
          Text(
            visualizacion,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Color(color),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
      ],
    );
  }
}
