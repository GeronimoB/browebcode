import 'package:flutter/material.dart';

import '../common/sizes.dart';

Widget imageItem(String imageUrl, DateTime datetime, bool sent, bool read) {
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
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Sizes.radius),
            bottomRight: Radius.circular(Sizes.radius),
            topRight: Radius.circular(sent ? 0 : Sizes.radius),
            topLeft: Radius.circular(sent ? Sizes.radius : 0),
          ),
          border: Border.all(
            color: sent
                ? const Color.fromARGB(107, 4, 255, 0)
                : const Color.fromARGB(51, 255, 255, 255),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.radius),
            child: Image.network(imageUrl),
          ),
          SizedBox(height: Sizes.padding / 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                datetime.toIso8601String().substring(11, 16),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Sizes.font14,
                ),
              ),
              const SizedBox(width: 5),
              sent
                  ? Icon(read ? Icons.done_all : Icons.check,
                      size: 16, color: const Color.fromARGB(255, 215, 214, 214))
                  : Container(),
            ],
          ),
        ],
      ),
    ),
  );
}
