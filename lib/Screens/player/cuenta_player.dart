import 'dart:convert';
import 'dart:io';

import 'package:bro_app_to/Screens/metodo_pago_screen.dart';
import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/components/avatar_placeholder.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/Screens/planes_pago.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:http/http.dart' as http;

import '../../components/i_field.dart';
import '../../utils/api_client.dart';

class CuentaPage extends StatefulWidget {
  const CuentaPage({super.key});

  @override
  CuentaPageState createState() => CuentaPageState();
}

class CuentaPageState extends State<CuentaPage> {
  bool deslizadorActivado = true;
  bool expanded = false;
  final picker = ImagePicker();
  bool _isExpanded = false;
  late UserProvider userProvider;
  late PlayerProvider playerProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
  }

  Future<void> _openGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    } else {
      debugPrint('No image selected.');
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final player = playerProvider.getPlayer()!;
    const url = '${ApiConstants.baseUrl}/auth/upload-player-image';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files
        .add(await http.MultipartFile.fromPath('imagen', imageFile.path));
    request.fields["userId"] = player.userId ?? '0';
    request.fields["isAgent"] = player.isAgent.toString();
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      final image = jsonDecode(responseBody)["image"];
      playerProvider.updateLocalImage(image);
      userProvider.updateLocalImage(image);
      debugPrint('Image uploaded successfully');
    } else {
      debugPrint('Failed to upload image. Error code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final player = playerProvider.getPlayer()!;
    DateTime? birthDate = player.birthDate;

    String formattedDate =
        birthDate != null ? DateFormat('dd-MM-yyyy').format(birthDate) : '';
    String shortInfo =
        '${player.provincia}, ${player.pais}\n Fecha de nacimiento: $formattedDate';
    String fullInfo =
        '${player.provincia}, ${player.pais}\n Fecha de nacimiento: $formattedDate\n Categoría: ${player.categoria}\n Posición: ${player.position}\nEntidad deportiva: ${player.club}\n Selección: ${player.seleccionNacional} ${player.categoriaSeleccion}\n Pie Dominante: ${player.pieDominante} \n Logros: ${player.logrosIndividuales}  \n Altura: ${player.altura}';

    double width = MediaQuery.of(context).size.width;
    print(width);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 44, 44, 44),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: appBarTitle('CUENTA'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E050),
              size: 32,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _openGallery,
              child: Stack(
                children: [
                  ClipOval(
                    child: player.userImage != ''
                        ? ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.grey.withOpacity(0.5),
                              BlendMode.dstATop,
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  AvatarPlaceholder(150),
                              errorWidget: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/fot.png',
                                  fit: BoxFit.fill,
                                  width: 150,
                                  height: 150,
                                );
                              },
                              imageUrl: player.userImage ?? '',
                              fit: BoxFit.fill,
                              width: 150,
                              height: 150,
                            ),
                          )
                        : ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.grey.withOpacity(0.5),
                              BlendMode.dstATop,
                            ),
                            child: Image.asset(
                              'assets/images/fot.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const Positioned(
                    bottom: 0,
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${player.name} ${player.lastName}',
              style: const TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _isExpanded ? fullInfo : shortInfo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Ver menos' : 'Ver más',
                style: const TextStyle(
                  color: Color(0xFF05FF00),
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 310.0,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: width > 550 ? 0.5 : 0.8,
                ),
                items: planes.map((plan) {
                  final isActualPlan =
                      userProvider.getCurrentUser().subscription == plan.nombre;
                  return Container(
                    width: 360,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: const Color(0xFF05FF00)),
                      boxShadow: isActualPlan
                          ? [
                              const CustomBoxShadow(
                                  color: Color(0xFF05FF00), blurRadius: 10)
                            ]
                          : null,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/icons/Logo.svg',
                                  width: 80),
                              Text(
                                plan.nombre,
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF05FF00),
                                    height: 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Que incluye:',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            expanded ? plan.descripcionLarga : plan.descripcion,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: expanded ? 100 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                expanded = !expanded;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF05FF00),
                            ),
                            child:
                                Text(expanded ? 'Ver menos...' : 'Ver más...'),
                          ),
                          Center(
                            child: CustomTextButton(
                              onTap: () {
                                if (!isActualPlan) {
                                  final precio =
                                      plan.precio.replaceAll(',', '.');
                                  final precioDouble = double.parse(precio);
                                  playerProvider.isSubscriptionPayment = true;
                                  playerProvider.isNewSubscriptionPayment =
                                      false;
                                  playerProvider.selectPlan(plan);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MetodoDePagoScreen(
                                              valueToPay: precioDouble,
                                            )),
                                  );
                                } else {
                                  confirmationCancelDialog(
                                      context, playerProvider);
                                }
                              },
                              text: isActualPlan ? 'Cancelar' : 'Subscribirse',
                              buttonPrimary: true,
                              width: 116,
                              height: 42,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 104,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void confirmationCancelDialog(BuildContext context, PlayerProvider provider) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) {
        TextEditingController ctlr = TextEditingController();
        return Dialog(
            backgroundColor: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xff3B3B3B),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(5, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Text(
                      '¿Estás seguro de que quieres cancelar tu suscripción?',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff00E050),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Ingrese el motivo de la cancelación',
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1),
                    ),
                    iField(ctlr, ''),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextButton(
                          onTap: () => Navigator.of(context).pop(),
                          text: 'Cancelar',
                          buttonPrimary: false,
                          width: 90,
                          height: 27,
                        ),
                        CustomTextButton(
                          onTap: () async {
                            final id = provider.getPlayer()!.userId;

                            await ApiClient().post('auth/cancel-subscription',
                                {"userId": id, "reason": ctlr.text});
                            Navigator.of(context).pop();
                          },
                          text: 'Continuar',
                          buttonPrimary: true,
                          width: 90,
                          height: 27,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
