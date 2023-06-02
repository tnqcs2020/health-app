import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronglier/screens/auth/auth_screen.dart';
import 'package:stronglier/screens/drawer/drawer_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  TextEditingController textController = TextEditingController();
  final userGlobal = Get.put(UserGlobal());
  String? finalEmail;

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {
      if (finalEmail != null) {
        GV.userCol.where('email', isEqualTo: finalEmail).get().then((user) {
          if (user.docs.isNotEmpty) {
            userGlobal.setUser(
              idGlobal: '${user.docs[0]['idU']}'.obs,
              nameGlobal: '${user.docs[0]['name']}'.obs,
              emailGlobal: '${user.docs[0]['email']}'.obs,
              typeGlobal: '${user.docs[0]['type']}'.obs,
              avatarGlobal: '${user.docs[0]['avatar']}'.obs,
            );
          }
        });
      }
      Timer(
        const Duration(seconds: 3),
        () => Get.offUntil(
          MaterialPageRoute(
              builder: (_) => (finalEmail == null)
                  ? const AuthScreen()
                  : const DrawerScreen()),
          (route) => false,
        ),
      );
    });
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = ColorTween(begin: Colors.white70, end: Colors.white)
        .animate(controller!);
    controller!.forward();
    controller!.addListener;
  }

  Future getValidationData() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPref.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Container(
        decoration: const BoxDecoration(
          color: GV.primaryColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 45.0,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('STRONGLIER'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
