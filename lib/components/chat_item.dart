import 'package:flutter/material.dart';

Widget chatItem(
  String message,
  DateTime datetime,
  bool sent,
  bool read,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
                      fontSize: 12,
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
                  color: Color.fromARGB(255, 215, 214, 214),
                )
              : Container(),
        ],
      ),
    ),
  );
}
