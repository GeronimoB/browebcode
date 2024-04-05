import 'package:bro_app_to/Screens/metodo_pago_screen.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Define el widget de detalles de planes
class PlanDetailsScreen extends StatelessWidget {
  final String goldPlan;
  final List<String> planItems;
  final String price;

  // Constructor que asigna los parámetros
  PlanDetailsScreen({
    required this.goldPlan,
    required this.planItems,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'PLANES',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/Logo.svg',
                  width: 30,
                  height: 30,
                ),
                Text(
                  goldPlan,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    color: Color(0xff00E050),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Espacio
            SizedBox(height: 20),
            // Lista de elementos del plan
            ...generatePlanItems(planItems),
            // Descripción en latín
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
                style: const TextStyle(fontFamily: 'Montserrat'),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Columna del precio
                Column(
                  children: <Widget>[
                    const Text(
                      '1 MES',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff00E050),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CustomTextButton(
                  onTap: () {
                    final String priceString = price.replaceAll(',', '.');
                    final double? priceDouble = double.tryParse(priceString);
                    if (priceDouble != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MetodoDePagoScreen(
                            valueToPay: priceDouble,
                          ),
                        ),
                      );
                    } else {
                      print('El precio no es un número válido.');
                    }
                  },
                  text: ' Subscribirse',
                  buttonPrimary: true,
                  width: 116,
                  height: 39,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> generatePlanItems(List<String> items) {
    return items.map((item) {
      return ListTile(
        title: Text(
          item,
          style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white),
        ),
        leading: Icon(Icons.check,
            color: Color(0xff00E050)), // Icono con check verde
      );
    }).toList();
  }
}
