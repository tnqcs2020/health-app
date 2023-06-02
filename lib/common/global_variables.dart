import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronglier/common/user_controller.dart';

class GV {
  //Color
  static const Color primaryColor = Color(0xFF007AD0);
  static const Color secondaryColor = Colors.blue;
  static const Color backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color.fromARGB(255, 244, 244, 244);
  static const Color drawerItemColor = Colors.black87;
  static const Color drawerItemSelectedColor = Color(0xFF007AD0);
  static const Color drawerSelectedTileColor =
      Color.fromARGB(180, 180, 230, 250);

  //style
  static TextStyle robotoRegular() => const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );
  static TextStyle robotoMedium() => const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
  static TextStyle robotoBold() => const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
  static TextInputFormatter inputFormat = FilteringTextInputFormatter.allow(RegExp(
      r"[aAàÀảẢãÃáÁạẠăĂằẰẳẲẵẴắẮặẶâÂầẦẩẨẫẪấẤậẬbBcCdDđĐeEèÈẻẺẽẼéÉẹẸêÊềỀểỂễỄếẾệỆfFgGhHiIìÌỉỈĩĨíÍịỊjJkKlLmMnNoOòÒỏỎõÕóÓọỌôÔồỒổỔỗỖốỐộỘơƠờỜởỞỡỠớỚợỢpPqQrRsStTuUùÙủỦũŨúÚụỤưƯừỪửỬữỮứỨựỰvVwWxXyYỳỲỷỶỹỸýÝỵỴzZ0-9]"));

  //image
  static const List<String> banner = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/banner4.jpg',
  ];
  static const String noImage = 'assets/images/no_image.png';

  //firebase
  static final auth = FirebaseAuth.instance;
  static final userCol = FirebaseFirestore.instance.collection('users');
  static final vaccineCol = FirebaseFirestore.instance.collection('vaccines');
  static final locationCol =
      FirebaseFirestore.instance.collection('vacFacilities');
  static final healthRecordCol =
      FirebaseFirestore.instance.collection('healthRecords');
  static final vacHistoryCol =
      FirebaseFirestore.instance.collection('vaccineHistorys');

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ));
}
