import 'dart:ffi';

import 'package:bro_app_to/components/avatar_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget chatAvatar(int count, String imageUrl) {
  return Container(
    width: 64,
    height: 64,
    alignment: Alignment.topLeft,
    child: Stack(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            placeholder: (context, url) => AvatarPlaceholder(64),
            errorWidget: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/fot.png',
                fit: BoxFit.fill,
                width: 64,
                height: 64,
              );
            },
            imageUrl: imageUrl,
            fit: BoxFit.fill,
            width: 64,
            height: 64,
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
