import 'package:flutter/material.dart';

import '../common/sizes.dart';

Widget chatItem(
  String message,
  DateTime datetime,
  bool sent,
  bool read,
) {
  return Container(
    width: Sizes.width,
    padding: EdgeInsets.symmetric(horizontal: Sizes.padding),
    alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      width: Sizes.width * 0.65,
      margin: EdgeInsets.symmetric(vertical: Sizes.padding / 4),
      padding: EdgeInsets.symmetric(
          horizontal: Sizes.padding / 2, vertical: Sizes.padding / 4),
      decoration: BoxDecoration(
          color: sent
              ? const Color.fromARGB(51, 4, 255, 0)
              : const Color.fromARGB(51, 255, 255, 255),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: sent
                ? const Color.fromARGB(107, 4, 255, 0)
                : const Color.fromARGB(51, 255, 255, 255),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10 / 4),
                Text(
                  datetime.toIso8601String().substring(11, 16),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          sent
              ? Icon(
                  read ? Icons.done_all : Icons.check,
                  size: 16,
                  color: const Color.fromARGB(255, 215, 214, 214),
                )
              : Container(),
        ],
      ),
    ),
  );
}
