import 'dart:convert';

import 'package:bro_app_to/Screens/bottom_navigation_bar.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/api_client.dart';
import 'package:http/http.dart' as http;

class AgregarTarjetaScreen extends StatefulWidget {
  const AgregarTarjetaScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AgregarTarjetaScreenState createState() => _AgregarTarjetaScreenState();
}

class _AgregarTarjetaScreenState extends State<AgregarTarjetaScreen> {
  final controller = CardFormEditController();
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    controller.addListener(update);
  }

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  void update() => setState(() {});
  @override
  Widget build(BuildContext context) {
    String imagenTarjeta = 'visa' == 'visa'
        ? 'assets/images/Visa_icon.png'
        : 'assets/images/Mastercard_icon.png';

    return Container(
        height: MediaQuery.of(context).size.height,
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
              'MÉTODO DE PAGO',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent, // AppBar transparente
            elevation: 0, // Quitar sombra
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF00E050),
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: Colors.transparent, // Fondo de scaffold transparente
          body: Container(
            padding: const EdgeInsets.all(26.0),
            width: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Disponibles',
                    style: TextStyle(
                        color: Color(0xFF00E050),
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF00E050)),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: isSelected
                            ? [
                                const CustomBoxShadow(
                                    color: Color(0xFF00E050), blurRadius: 4)
                              ]
                            : null),
                    child: ListTile(
                      leading: Image.asset(imagenTarjeta),
                      title: const Text(
                        'Titular XXXXXXXX\nNúmero XXXXXXXXXXXX',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        softWrap: false,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF00E050)),
                        onPressed: () {
                          // Acción para eliminar tarjeta
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Agregar Tarjeta',
                    style: TextStyle(
                        color: Color(0xFF00E050),
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                CardFormField(
                  countryCode: 'ES',
                  enablePostalCode: false,
                  onCardChanged: (details) {
                    print(details);
                    if (controller.details.complete) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  controller: controller,
                  style: CardFormStyle(
                    // Estilo del texto dentro del campo
                    backgroundColor: Colors.white,
                    borderWidth: 2,
                    borderColor: Colors.green,
                    borderRadius: 15,
                    fontSize: 14,
                    textColor: Colors.black,
                  ),
                ),
                CustomTextButton(
                    onTap: controller.details.complete == true
                        ? () {
                            _handlePayPress();
                          }
                        : null,
                    text: 'Añadir Tarjeta',
                    buttonPrimary: true,
                    width: 233,
                    height: 30),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset('assets/icons/Logo.svg', width: 80),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _handlePayPress() async {
    if (!controller.details.complete) {
      return;
    }

    try {
      // 1. Gather customer billing information (ex. email)
      final playerProvider =
          Provider.of<PlayerProvider>(context, listen: false);

      final billingDetails = BillingDetails(
        email: playerProvider.getTemporalUser().email,
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ));
      print(paymentMethod.id);
      // // 3. call API to create PaymentIntent
      // final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
      //   useStripeSdk: true,
      //   paymentMethodId: paymentMethod.id,
      //   currency: 'eur', // mocked data
      //   items: ['id-1'],
      // );

      // if (paymentIntentResult['error'] != null) {
      //   // Error during creating or confirming Intent
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('Error: ${paymentIntentResult['error']}')));
      //   return;
      // }

      // if (paymentIntentResult['clientSecret'] != null &&
      //     paymentIntentResult['requiresAction'] == null) {
      //   // Payment succedeed

      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content:
      //           Text('Success!: The payment was confirmed successfully!')));
      //   return;
      // }

      // if (paymentIntentResult['clientSecret'] != null &&
      //     paymentIntentResult['requiresAction'] == true) {
      //   // 4. if payment requires action calling handleNextAction
      //   final paymentIntent = await Stripe.instance
      //       .handleNextAction(paymentIntentResult['clientSecret']);

      //   // todo handle error
      //   /*if (cardActionError) {
      //   Alert.alert(
      //   `Error code: ${cardActionError.code}`,
      //   cardActionError.message
      //   );
      // } else*/

      //   if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
      //     // 5. Call API to confirm intent
      //     await confirmIntent(paymentIntent.id);
      //   } else {
      //     // Payment succedeed
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text('Error: ${paymentIntentResult['error']}')));
      //   }
      // }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<String>? items,
  }) async {
    final response = await ApiClient().post(
      '/pay-without-webhooks',
      {
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items
      },
    );

    return json.decode(response.body);
  }
}
