import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Screens/agent/user_profile/user_profile_to_agent.dart';
import '../Screens/player/bottom_navigation_bar_player.dart';
import '../providers/user_provider.dart';
import '../utils/current_state.dart';

class PlayerHelper {
  static (String, String) getPlayerInfoFormatted(PlayerFullModel? player) {
    String shortInfo = '';
    String fullInfo = '';

    String? province = provincesByCountry[player?.pais]?[player?.provincia];
    String? country = countries[player?.pais];

    if (province != null && country != null) {
      shortInfo = '$province, $country';
    } else if (province != null) {
      shortInfo = province;
    } else if (country != null) {
      shortInfo = country;
    }

    DateTime? birthDate = player?.birthDate;
    if (birthDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(birthDate);
      shortInfo += '\n${translations!["birthdate"]}: $formattedDate';
    }

    if (province != null && country != null) {
      fullInfo = '$province, $country\n';
    } else if (province != null) {
      fullInfo = '$province\n';
    } else if (country != null) {
      fullInfo = '$country\n';
    }

    if (birthDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(birthDate);
      fullInfo += '${translations!["birthdate"]}: $formattedDate\n';
    }

    String? categoria = categorias[player?.categoria];
    if (categoria != null) {
      fullInfo += '${translations!["Categorys"]}: $categoria\n';
    }

    String? posicion = posiciones[player?.position];
    if (posicion != null) {
      fullInfo += '${translations!["position_label"]}: $posicion\n';
    }

    if (player?.club != null && player!.club!.isNotEmpty) {
      fullInfo += '${translations!["club_label"]}: ${player.club}\n';
    }

    String? seleccion = selecciones[player?.seleccionNacional];
    String? categoriaSeleccion = (player?.seleccionNacional != null &&
            nationalCategories.containsKey(player?.seleccionNacional) &&
            player?.categoriaSeleccion != null &&
            nationalCategories[player?.seleccionNacional]!
                .containsKey(player?.categoriaSeleccion))
        ? nationalCategories[player?.seleccionNacional]![
            player?.categoriaSeleccion]!
        : null;

    if (seleccion != null || categoriaSeleccion != null) {
      fullInfo += '${translations!["national_selection_short"]}:';
      if (seleccion != null) fullInfo += ' $seleccion';
      if (categoriaSeleccion != null) fullInfo += ' $categoriaSeleccion';
      fullInfo += '\n';
    }

    String? pie = piesDominantes[player?.pieDominante];
    if (pie != null) {
      fullInfo += '${translations!["dominant_feet"]}: $pie\n';
    }

    if (player?.altura != null && player!.altura!.isNotEmpty) {
      fullInfo += '${translations!["height_label"]}: ${player.altura}\n';
    }

    if (player?.logrosIndividuales != null &&
        player!.logrosIndividuales!.isNotEmpty) {
      fullInfo +=
          '${translations!["Achievements2"]}: ${player.logrosIndividuales}\n';
    }

    return (shortInfo, fullInfo);
  }

  static void navigateToFriendProfile(String friendID, BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final usuario = userProvider.getCurrentUser();
    String userId = usuario.userId;

    if (userId == friendID) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CustomBottomNavigationBarPlayer(
            initialIndex: 4,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerProfileToAgent(
            userId: friendID,
          ),
        ),
      );
    }
  }
}
