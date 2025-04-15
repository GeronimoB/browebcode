import 'package:bro_app_to/Screens/player/home_page/models/user_in_filter.dart';
import 'package:flutter/material.dart';

import '../../../agent/user_profile/user_profile_to_agent.dart';

Widget SearchUsersResult(
  BuildContext context,
  List<UserInFilter> usuariosFiltrados,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    constraints: const BoxConstraints(
      maxHeight: 400,
    ),
    child: Material(
      borderRadius: BorderRadius.circular(15),
      elevation: 5.0,
      shadowColor: Colors.black.withOpacity(0.5),
      color: const Color(0xFF3B3B3B),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xff3B3B3B),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(5, 4),
            ),
          ],
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: usuariosFiltrados
              .map((e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[800],
                      backgroundImage:
                          e.imageUrl != null && e.imageUrl!.isNotEmpty
                              ? NetworkImage(e.imageUrl!)
                              : null,
                      child: e.imageUrl == null || e.imageUrl!.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      e.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${e.name} ${e.lastName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerProfileToAgent(
                            userId: e.id.toString(),
                          ),
                        ),
                      ),
                      child: const Icon(Icons.chevron_right,
                          color: Color(0xFF05FF00)),
                    ),
                  ))
              .toList(),
        ),
      ),
    ),
  );
}
