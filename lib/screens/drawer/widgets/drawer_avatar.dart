import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/screens/drawer/drawer_screen.dart';

class DrawerAvatar extends StatelessWidget {
  DrawerAvatar({Key? key}) : super(key: key);
  final userGlobal = Get.put(UserGlobal());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: GV.primaryColor,
          image: userGlobal.avatar.value != ''
              ? DecorationImage(
                  image: CachedNetworkImageProvider(
                    userGlobal.avatar.value,
                    cacheManager: GV.customCacheManager,
                  ),
                  fit: BoxFit.cover,
                )
              : null,
          border: indexClicked == 0
              ? Border.all(color: Colors.blue, width: 3)
              : null,
        ),
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.only(bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (userGlobal.avatar.value == '')
              const Icon(
                Icons.person,
                size: 70,
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white70,
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    userGlobal.name.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    userGlobal.email.value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
