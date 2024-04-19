import 'dart:convert';

import 'package:bro_app_to/Screens/player/bottom_navigation_bar_player.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../components/app_bar_title.dart';
import '../providers/player_provider.dart';
import '../utils/api_client.dart';
import 'package:http/http.dart' as http;

import '../utils/api_constants.dart';
import '../utils/tarjeta_model.dart';
import 'package:http_parser/http_parser.dart';

class AgregarTarjetaScreen extends StatefulWidget {
  const AgregarTarjetaScreen({Key? key}) : super(key: key);

  @override
  AgregarTarjetaScreenState createState() => AgregarTarjetaScreenState();
}

class AgregarTarjetaScreenState extends State<AgregarTarjetaScreen> {
  final controller = CardFormEditController();
  int isSelected = -1;
  bool _isLoading = false;
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
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C2C2C), Color(0xFF000000)],
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: appBarTitle('MÉTODO DE PAGO'),
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
            resizeToAvoidBottomInset: false,
            body: Container(
              height: MediaQuery.of(context).size.height - 100,
              padding: const EdgeInsets.all(26.0),
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Disponibles',
                      style: const TextStyle(
                          color: Color(0xFF00E050),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(0),
                    height: playerProvider.getSavedCards()!.isEmpty
                        ? 0
                        : playerProvider.getSavedCards()!.length < 3
                            ? MediaQuery.of(context).size.height * 0.15
                            : MediaQuery.of(context).size.height * 0.25,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: playerProvider.getSavedCards()!.length,
                      itemBuilder: (context, index) {
                        Tarjeta tarjeta =
                            playerProvider.getSavedCards()![index];
                        final player = playerProvider.getPlayer() ??
                            playerProvider.getTemporalUser();
                        final String titular =
                            '${player.name} ${player.lastName}';
                        return _buildListCard(
                            tarjeta, index, titular, playerProvider);
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      'Agregar Tarjeta',
                      style: const TextStyle(
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
                      if (controller.details.complete) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    controller: controller,
                    style: CardFormStyle(
                      backgroundColor: Colors.white,
                      borderWidth: 2,
                      borderColor: const Color(0xFF00E050),
                      cursorColor: const Color(0xFF00E050),
                      borderRadius: 15,
                      fontSize: 14,
                      textColor: Colors.black,
                      placeholderColor: Colors.black,
                    ),
                  ),
                  CustomTextButton(
                      onTap: controller.details.complete == true
                          ? () {
                              _handleAddCard();
                            }
                          : () => FocusScope.of(context).unfocus(),
                      text: 'Añadir Tarjeta',
                      buttonPrimary: false,
                      width: 233,
                      height: 32),
                  const SizedBox(height: 16.0),
                  CustomTextButton(
                      onTap: () {
                        _handlePressPay();
                      },
                      text: 'Pagar',
                      buttonPrimary: true,
                      width: 233,
                      height: 30),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child:
                          SvgPicture.asset('assets/icons/Logo.svg', width: 80),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black
                  .withOpacity(0.5), // Color de fondo semitransparente
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF05FF00)), // Color del loader
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              contentPadding: const EdgeInsets.all(25),
              backgroundColor: const Color(0xFF3B3B3B),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Estamos subiendo tu vídeo, esto puede tardar unos segundos…",
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  LinearProgressIndicator(
                    color: Color(0xff00E050),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListCard(Tarjeta tarjeta, int index, String titular,
      PlayerProvider playerProvider) {
    return GestureDetector(
      onTap: () {
        playerProvider.setSelectedCard(tarjeta);
        setState(() {
          isSelected = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00E050)),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: isSelected == index
                ? [
                    const CustomBoxShadow(
                        color: Color(0xFF05FF00), blurRadius: 6)
                  ]
                : null,
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            leading: Image.asset(
              tarjeta.displayBrand == 'visa'
                  ? 'assets/images/Visa_icon.png'
                  : 'assets/images/Mastercard_icon.png',
              width: 70,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titular,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '************${tarjeta.last4Numbers}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  softWrap: false,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF00E050), size: 32),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                final player = playerProvider.getPlayer() ??
                    playerProvider.getTemporalUser();
                final asociatePaymentMethod = await ApiClient().post(
                  'security_filter/v1/api/payment/delete-payment-method',
                  {
                    "paymentMethodId": tarjeta.cardId,
                    "customerId": player.customerStripeId,
                  },
                );

                if (asociatePaymentMethod.statusCode != 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                          'Error al eliminar la tarjeta, intentelo de nuevo.'),
                    ),
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                }
                setState(() {
                  _isLoading = false;
                });
                final savedCards =
                    jsonDecode(asociatePaymentMethod.body)["paymentMethods"];
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Color(0xFF05FF00),
                      content:
                          Text('La tarjeta se ha eliminado exitosamente.')),
                );
                playerProvider.setCards(mapListToTarjetas(savedCards));
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddCard() async {
    if (!controller.details.complete) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      // 1. Gather customer billing information (ex. email)
      final playerProvider =
          Provider.of<PlayerProvider>(context, listen: false);
      final player =
          playerProvider.getPlayer() ?? playerProvider.getTemporalUser();
      final billingDetails = BillingDetails(
        email: player.email,
      );

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ));

      final customerId = player.customerStripeId;
      controller.clear();
      final asociatePaymentMethod = await ApiClient().post(
        'security_filter/v1/api/payment/payment-method',
        {
          "paymentMethodId": paymentMethod.id.toString(),
          "customerId": customerId,
        },
      );

      if (asociatePaymentMethod.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Error al guardar la tarjeta, intentelo de nuevo.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final savedCards =
          jsonDecode(asociatePaymentMethod.body)["paymentMethods"];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Color(0xFF05FF00),
            content: Text('La tarjeta se ha agregado exitosamente.')),
      );
      playerProvider.setCards(mapListToTarjetas(savedCards));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent, content: Text('Error: $e')));
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  Future<void> _handlePressPay() async {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final isSubscription = playerProvider.isSubscriptionPayment;
    final player =
        playerProvider.getPlayer() ?? playerProvider.getTemporalUser();

    if (playerProvider.selectedCard == null) {
      _showErrorSnackBar('Selecciona la tarjeta con la cual deseas pagar.');
      return;
    }

    try {
      _setLoadingState(true);

      if (isSubscription) {
        await _handleSubscriptionPayment(player, playerProvider);
      } else {
        await _handleFavoriteVideoPayment(player, playerProvider);
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
      _setLoadingState(false);
      rethrow;
    }
  }

  Future<void> _handleSubscriptionPayment(
      PlayerFullModel player, PlayerProvider playerProvider) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final subscriptionIntent = await ApiClient().post(
      'security_filter/v1/api/payment/subscription',
      {
        "planId": playerProvider.getActualPlan()!.idPlan,
        "customerId": player.customerStripeId,
        "paymentMethodId": playerProvider.selectedCard!.cardId,
        "paymentMethod":
            "${playerProvider.selectedCard!.displayBrand!.toUpperCase()} *${playerProvider.selectedCard!.last4Numbers}",
        "plan": playerProvider.getActualPlan()!.nombre,
        "userId": player.userId,
        "amount": playerProvider.getActualPlan()!.precio,
        "isSuscription": "1"
      },
    );

    if (subscriptionIntent.statusCode != 200) {
      _showErrorSnackBar('Error al pagar, inténtelo de nuevo.');
      _setLoadingState(false);
      return;
    }

    _setLoadingState(false);

    if (playerProvider.isNewSubscriptionPayment) {
      _showSuccessSnackBar('Su pago se ha procesado exitosamente.');
      await Future.delayed(const Duration(seconds: 1));

      userProvider.setCurrentUser(UserModel.fromPlayer(player,
          status: true, plan: playerProvider.getActualPlan()?.nombre));
      playerProvider.setNewUser();
      _showUploadDialog();
      final video = playerProvider.videoPathToUpload;
      final image = playerProvider.imagePathToUpload;
      final userId = player.userId;
      uploadVideoAndImage(video, image, userId);
    } else {
      userProvider.updatePlan(playerProvider.getActualPlan()!.nombre);
      _showSuccessSnackBar('¡Felicidades, haz actualizado tu suscripcion!');
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const CustomBottomNavigationBarPlayer()),
      );
    }
  }

  Future<void> _handleFavoriteVideoPayment(
      PlayerFullModel player, PlayerProvider playerProvider) async {
    final video = playerProvider.videoProcessingFavoritePayment;
    final destacarVideo = await ApiClient().post(
      'security_filter/v1/api/payment/subscription',
      {
        "planId": "price_1P2RbpIkdX2ffauue0ZIWVUn",
        "customerId": player.customerStripeId,
        "paymentMethodId": playerProvider.selectedCard!.cardId,
        "paymentMethod":
            "${playerProvider.selectedCard!.displayBrand!.toUpperCase()} *${playerProvider.selectedCard!.last4Numbers}",
        "plan": "Destacar video",
        "userId": player.userId,
        "amount": "0.99",
        "isSuscription": "0",
        'videoId': video?.id.toString(),
      },
    );

    if (destacarVideo.statusCode != 200) {
      _showErrorSnackBar('Error al pagar, inténtelo de nuevo.');
      _setLoadingState(false);
      return;
    }

    playerProvider.indexProcessingVideoFavoritePayment = 0;
    playerProvider.videoProcessingFavoritePayment = null;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              const CustomBottomNavigationBarPlayer(initialIndex: 4)),
    );
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF05FF00),
        content: Text(message),
      ),
    );
  }

  Future<void> uploadVideoAndImage(
      String? videoPath, Uint8List? uint8list, String? userId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/auth/uploadFiles'),
    );
    request.fields["userId"] = userId ?? '';
    if (videoPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        videoPath,
      ));
    }

    if (uint8list != null) {
      // Adjuntar los bytes de la imagen al cuerpo de la solicitud
      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        uint8list,
        filename: 'imagen.png',
        contentType: MediaType('image', 'png'),
      ));
    }

    // Enviar la solicitud al servidor y esperar la respuesta
    var response = await request.send();

    // Verificar el estado de la respuesta
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const CustomBottomNavigationBarPlayer()),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              'Hubo un error al cargar tu video, intentalo de nuevo desde tu perfil.')));
      Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const CustomBottomNavigationBarPlayer()),
      );
    }
  }
}
