import 'package:bro_app_to/Screens/metodo_pago_screen.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanDetailsScreen extends StatelessWidget {
  final String goldPlan;
  final List<String> planItems;
  final String price;

  const PlanDetailsScreen({
    super.key,
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
             Text(
              translations!["PLANS"],
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
            const SizedBox(height: 20),
            ...generatePlanItems(planItems),
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                translations!["loremIpsum"],
                style: const TextStyle(fontFamily: 'Montserrat'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                     Text(
                      translations!["oneMonth"],
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
                    } else {}
                  },
                  text: translations!["subscribe"],
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
        leading: const Icon(
          Icons.check,
          color: Color(0xff00E050),
          size: 32,
        ),
      );
    }).toList();
  }
}
