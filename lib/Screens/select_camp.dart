import 'dart:async';
import 'dart:convert';

import 'package:bro_app_to/Screens/first_video.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../components/custom_text_button.dart';
import '../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class SelectCamp extends StatefulWidget {
  const SelectCamp({super.key});

  @override
  SelectCampState createState() => SelectCampState();
}

class SelectCampState extends State<SelectCamp> {
  bool _acceptedTerms = false;
  late List<Player> players;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    players = [
      Player(position: "Portero", number: "1"),
      Player(position: "Lateral Derecho", number: "2"),
      Player(position: "Lateral Izquierdo", number: "3"),
      Player(position: "Defensa Central Derecho", number: "4"),
      Player(position: "Defensa Central Izquierdo", number: "5"),
      Player(position: "Mediocampista Defensivo", number: "6"),
      Player(position: "Mediocampista Derecho", number: "7"),
      Player(position: "Mediocampista Central", number: "8"),
      Player(position: "Delantero Centro", number: "9"),
      Player(position: "Mediocampista Ofensivo", number: "10"),
      Player(position: "Extremo Izquierdo", number: "11"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            top: screenSize.height * 0.1,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Campo.png',
              width: screenSize.width,
              height: screenSize.height * 0.6,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: screenSize.height * 0.1,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Color.fromARGB(255, 40, 40, 40),
                    Color.fromARGB(0, 43, 43, 43),
                  ],
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 394,
            ),
          ),
          playerPic(
            "Portero",
            "1",
            screenSize.height * 0.55,
            screenSize.width * 0.43,
          ),
          playerPic(
            "Lateral Derecho",
            "2",
            screenSize.height * 0.52,
            screenSize.width * 0.85,
          ),
          playerPic(
            "Lateral Izquierdo",
            "3",
            screenSize.height * 0.52,
            screenSize.width * 0.01,
          ),
          playerPic(
            "Defensa Central Derecho",
            "4",
            screenSize.height * 0.5,
            screenSize.width * 0.6,
          ),
          playerPic(
            "Defensa Central Izquierdo",
            "5",
            screenSize.height * 0.5,
            screenSize.width * 0.26,
          ),
          playerPic(
            "Mediocampista Defensivo",
            "6",
            screenSize.height * 0.45,
            screenSize.width * 0.17,
          ),
          playerPic(
            "Mediocampista Derecho",
            "7",
            screenSize.height * 0.41,
            screenSize.width * 0.73,
          ),
          playerPic(
            "Mediocampista Central",
            "8",
            screenSize.height * 0.45,
            screenSize.width * 0.67,
          ),
          playerPic(
            "Delantero Centro",
            "9",
            screenSize.height * 0.40,
            screenSize.width * 0.475,
          ),
          playerPic(
            "Mediocampista Ofensivo",
            "10",
            screenSize.height * 0.44,
            screenSize.width * 0.4,
          ),
          playerPic(
            "Extremo Izquierdo",
            "11",
            screenSize.height * 0.41,
            screenSize.width * 0.1,
          ),
          Positioned(
            top: screenSize.height * 0.7,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptedTerms = value!;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return const Color(
                                  0xff00E050); // Color cuando está seleccionado
                            }
                            return Colors
                                .white; // Color por defecto (fondo blanco)
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Bordes redondeados
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptedTerms = !_acceptedTerms;
                            });
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Confirmo y acepto los ',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'Términos y Condiciones y he leído la Política de Privacidad.',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextButton(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (!_acceptedTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    'Por favor, acepta los terminos y condiciones.')),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                        if (!players.any((player) => player.isSelected)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content:
                                  Text('Por favor, selecciona una posición.'),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                        final selectedPlayer =
                            players.firstWhere((element) => element.isSelected);
                        final playerProvider =
                            Provider.of<PlayerProvider>(context, listen: false);
                        playerProvider.updateTemporalPlayer(
                          position: selectedPlayer.position,
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const FirstVideoWidget()),
                        // );
                        try {
                          final response = await ApiClient().post(
                            'auth/player',
                            playerProvider.getTemporalUser().toMap(),
                          );

                          if (response.statusCode == 200) {
                            final jsonData = jsonDecode(response.body);
                            final userId = jsonData["userInfo"]["userId"];

                            playerProvider.updateTemporalPlayer(
                              userId: userId.toString(),
                            );

                            final name =
                                "${playerProvider.getTemporalUser().name} ${playerProvider.getTemporalUser().lastName}";
                            final email =
                                playerProvider.getTemporalUser().email;

                            final responseStripe = await ApiClient().post(
                              'security_filter/v1/api/payment/customer',
                              {
                                "userId": userId.toString(),
                                "CompleteName": name,
                                "Email": email
                              },
                            );
                            if (responseStripe.statusCode != 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                      'Ha ocurrido un error al crear su cuenta, por favor intentelo de nuevo.'),
                                ),
                              );
                              return;
                            }
                            final jsonDataCus = jsonDecode(responseStripe.body);
                            final customerId = jsonDataCus["customerId"];
                            print("que me llega $customerId");
                            playerProvider.updateTemporalPlayer(
                                customerStripeId: customerId);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.lightGreen,
                                  content: Text(
                                      'Su cuenta se ha creado exitosamente, tiene 3 días para confirmar su correo.')),
                            );
                            Future.delayed(Duration(seconds: 2));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FirstVideoWidget()),
                            );
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            final jsonData = json.decode(response.body);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(jsonData["error"])),
                            );
                          }
                        } on TimeoutException {
                          // Si se produce un timeout, muestra un mensaje de error y devuelve false
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                  'Se ha producido un error. Por favor, inténtalo de nuevo.'),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      },
                      text: 'Siguiente',
                      buttonPrimary: true,
                      width: 116,
                      height: 39),
                  const SizedBox(
                      height:
                          10), // Espacio extra para evitar superposición con el logo
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.03,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/Logo.svg',
                width: 104,
              ),
            ),
          ),
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPositionDialog(String position, VoidCallback update) {
    bool? isSelected;
    bool aux = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              backgroundColor: const Color(0xFF3B3B3B),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "¿Eres $position?",
                    style: const TextStyle(
                        color: Color(0xff00E050),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<bool>(
                        value: true,
                        groupValue: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isSelected = value;
                            aux = true;
                          });
                        },
                        activeColor: const Color(0xff00E050),
                      ),
                      const Text("SÍ",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(width: 25),
                      Radio<bool>(
                        value: false,
                        groupValue: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isSelected = value;
                            aux = false;
                          });
                        },
                        activeColor: const Color(0xff00E050),
                      ),
                      const Text("NO",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ],
                  ),
                  CustomTextButton(
                      onTap: () {
                        setState(() {
                          players.forEach((player) {
                            if (player.position == position) {
                              player.isSelected = aux;
                            }
                          });
                          update.call();
                        });
                        Navigator.of(context).pop(isSelected);
                      },
                      text: "Listo",
                      buttonPrimary: true,
                      width: 174,
                      height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget playerPic(String position, String number, double top, double left) {
    // Encuentra el jugador correspondiente en la lista
    Player player = players.firstWhere(
      (element) => element.position == position,
      orElse: () => Player(position: position, number: number),
    );

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          _showPositionDialog(position, () {
            setState(() {});
          });
          handlePlayerSelection(player);
        },
        child: Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: player.isSelected
                      ? const Color(0xff05FF00)
                      : Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 1,
                    height: 1,
                  ),
                ),
              ),
            ),
            Image.asset('assets/images/football-player 1.png'),
          ],
        ),
      ),
    );
  }

  void handlePlayerSelection(Player selectedPlayer) {
    setState(() {
      for (var player in players) {
        if (player.position != selectedPlayer.position) {
          player.isSelected = false;
        } else {
          player.isSelected = true;
        }
      }
    });
  }
}

class Player {
  final String position;
  final String number;
  bool isSelected;
  final bool? isPositionConfirmed;

  Player({
    required this.position,
    required this.number,
    this.isSelected = false,
    this.isPositionConfirmed,
  });

  Player copyWith({
    String? position,
    String? number,
    bool? isSelected,
    bool? isPositionConfirmed,
  }) {
    return Player(
      position: position ?? this.position,
      number: number ?? this.number,
      isSelected: isSelected ?? this.isSelected,
      isPositionConfirmed: isPositionConfirmed ?? this.isPositionConfirmed,
    );
  }
}
