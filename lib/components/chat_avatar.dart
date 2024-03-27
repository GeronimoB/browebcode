import 'package:flutter/material.dart';

Widget chatAvatar(int count, String image) {
  return Container(
      width: 64,
      height: 64,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: count == 0
          ? Container()
          : Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xff32CF45),
                borderRadius: BorderRadius.all(Radius.circular(25 / 2)),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ));
}
