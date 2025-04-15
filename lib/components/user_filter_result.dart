import 'package:flutter/material.dart';

import '../Screens/agent/user_profile/user_profile_to_agent.dart';
import '../utils/initial_video_model.dart';

Widget userFilterResultWidget(
  BuildContext context,
  List<UserFilter> usuariosFiltrados,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    height: 150,
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
          children: [
            ...usuariosFiltrados
                .map((e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      e.user,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
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
                            userId: e.userId.toString(),
                          ),
                        ),
                      ),
                      child: const Icon(Icons.chevron_right,
                          color: Color(0xFF05FF00)),
                    )))
                .toList()
          ],
        ),
      ),
    ),
  );
}
