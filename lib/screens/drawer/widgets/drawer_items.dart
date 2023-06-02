import 'package:flutter/material.dart';
import 'package:stronglier/screens/account/account_screen.dart';
import 'package:stronglier/screens/health_record/health_record_screen.dart';
import 'package:stronglier/screens/home/home_screen.dart';
import 'package:stronglier/screens/user/user_screen.dart';
import 'package:stronglier/screens/vac_facility/vac_facility_screen.dart';
import 'package:stronglier/screens/vac_history/vac_history_screen.dart';
import 'package:stronglier/screens/vaccine/vaccine_screen.dart';

class DrawerItems {
  static final menu = [
    'Tài khoản',
    'Trang chủ',
    'Người dùng',
    'Hồ sơ khám bệnh',
    'Lịch sử tiêm chủng',
    'Vắc-xin',
    'Cơ sở tiêm chủng',
    'Đăng xuất',
  ];
  static final icon = [
    null,
    Icons.home_outlined,
    Icons.person_outlined,
    Icons.library_books_outlined,
    Icons.history_outlined,
    Icons.vaccines_outlined,
    Icons.location_on_outlined,
    Icons.logout_outlined,
  ];
  static final page = [
    const AccountScreen(inDrawer: true),
    const HomeScreen(),
    const UserScreen(),
    const HealthRecordScreen(),
    const VacHistoryScreen(),
    const VaccineScreen(),
    const VacFacilityScreen(),
    const SizedBox(),
  ];
}
