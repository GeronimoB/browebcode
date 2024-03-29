import 'package:flutter/material.dart';

Widget chatAvatar(int count, String imageUrl) {
  return Container(
    width: 64,
    height: 64,
    alignment: Alignment.topLeft,
    child: Stack(
      children: [
        ClipOval(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/fot.png',
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/fot.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              );
            },
            image: imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        if (count != 0)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xff32CF45),
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
