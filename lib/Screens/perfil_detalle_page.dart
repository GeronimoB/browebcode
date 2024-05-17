import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';

class PerfilDetallePage extends StatelessWidget {
  const PerfilDetallePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF00E050),
                size: 32,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              translations!["playerProfileInfo"],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: const SizedBox(width: 24), // To center the title
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 75.0,
                  backgroundImage: AssetImage(
                      'path/to/player/image.png'), // Tu imagen de jugador aquí.
                ),
                const SizedBox(height: 16),
                 Text(
                  translations!["fullName"],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${translations!["birthDate"]}\n ${translations!["countryProvince"]}\n${translations!["playingCategory"]}\n${translations!["sportsSchool"]}\n${translations!["individualAchievements"]}\n${translations!["nationalTeamSelectionU18"]}',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed: () {
                    // Acción para ir al chat
                  },
                  child:  Text(translations!["goToChat"],
                      style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
