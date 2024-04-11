import 'package:bro_app_to/Screens/player/edit_player_info.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/registration/presentation/screens/sign_up.dart';
import 'package:bro_app_to/src/registration/presentation/screens/sign_up_2.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
import '../../../../providers/player_provider.dart';

import '../../../../utils/current_state.dart';

class SelectCamp extends StatefulWidget {
  final bool registrando;
  const SelectCamp({super.key, required this.registrando});

  @override
  SelectCampState createState() => SelectCampState();
}

class SelectCampState extends State<SelectCamp> {
  late List<Player> players;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    players = [
      Player(position: translations!['goalKeeper'], number: "1"),
      Player(position: translations!['LD'], number: "2"),
      Player(position: translations!['LI'], number: "3"),
      Player(position: translations!['DFD'], number: "4"),
      Player(position: translations!['DFI'], number: "5"),
      Player(position: translations!['MCD'], number: "6"),
      Player(position: translations!['MDD'], number: "7"),
      Player(position: translations!['MDI'], number: "8"),
      Player(position: translations!['DC'], number: "9"),
      Player(position: translations!['MCO'], number: "10"),
      Player(position: translations!['EXT'], number: "11"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
              translations!['goalKeeper'],
              "1",
              screenSize.height * 0.55,
              screenSize.width * 0.43,
            ),
            playerPic(
              translations!['LD'],
              "2",
              screenSize.height * 0.52,
              screenSize.width * 0.85,
            ),
            playerPic(
              translations!['LI'],
              "3",
              screenSize.height * 0.52,
              screenSize.width * 0.01,
            ),
            playerPic(
              translations!['DFD'],
              "4",
              screenSize.height * 0.5,
              screenSize.width * 0.6,
            ),
            playerPic(
              translations!['DFI'],
              "5",
              screenSize.height * 0.5,
              screenSize.width * 0.26,
            ),
            playerPic(
              translations!['MCD'],
              "6",
              screenSize.height * 0.45,
              screenSize.width * 0.17,
            ),
            playerPic(
              translations!['MDD'],
              "7",
              screenSize.height * 0.41,
              screenSize.width * 0.73,
            ),
            playerPic(
              translations!['MDI'],
              "8",
              screenSize.height * 0.45,
              screenSize.width * 0.67,
            ),
            playerPic(
              translations!['DC'],
              "9",
              screenSize.height * 0.40,
              screenSize.width * 0.475,
            ),
            playerPic(
              translations!['MCO'],
              "10",
              screenSize.height * 0.44,
              screenSize.width * 0.4,
            ),
            playerPic(
              translations!['EXT'],
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
                    const SizedBox(height: 10),
                    CustomTextButton(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          final playerProvider = Provider.of<PlayerProvider>(
                              context,
                              listen: false);

                          if (!players.any((player) => player.isSelected)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(translations!['select_position']),
                              ),
                            );
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          final selectedPlayer = players
                              .firstWhere((element) => element.isSelected);
                          setState(() {
                            isLoading = false;
                          });
                          if (widget.registrando) {
                            playerProvider.updateTemporalPlayer(
                              position: selectedPlayer.position,
                            );

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpScreen2()));
                          } else {
                            playerProvider.updatePlayer(
                              fieldName: "position",
                              value: selectedPlayer.position,
                            );
                            final player = playerProvider.getPlayer()!;

                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);

                            userProvider.updateUserFromPlayer(player);

                            await ApiClient().post('auth/edit-player',
                                playerProvider.getPlayer()!.toMap());
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditarInfoPlayer()));
                          }
                        },
                        text: translations!['next'],
                        buttonPrimary: true,
                        width: 116,
                        height: 39),
                    const SizedBox(height: 10),
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                  ),
                ),
              ),
          ],
        ),
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
                          style: const TextStyle(
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
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ],
                  ),
                  CustomTextButton(
                      onTap: () {
                        setState(() {
                          for (var player in players) {
                            if (player.position == position) {
                              player.isSelected = aux;
                            }
                          }
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
    Player player = players.firstWhere(
      (element) => element.position == position,
      orElse: () => Player(position: position, number: number),
    );

    double initialTop = -100.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: initialTop, end: top),
      duration: const Duration(seconds: 2),
      builder: (context, animatedTop, child) {
        return Positioned(
          top: animatedTop,
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
      },
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
