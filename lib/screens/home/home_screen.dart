// ignore_for_file: invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/models/user_model.dart';
import 'package:stronglier/screens/account/account_screen.dart';
import 'package:stronglier/screens/health_record/widgets/add_health_record.dart';
import 'package:stronglier/screens/home/widgets/add_user_manager.dart';
import 'package:stronglier/screens/vac_facility/widgets/add_location.dart';
import 'package:stronglier/screens/vac_history/widgets/add_vac_history.dart';
import 'package:stronglier/screens/vaccine/widgets/add_vaccine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userGlobal = Get.put(UserGlobal());
  final uid = GV.auth.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: GV.banner.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return SizedBox(
                      width: Get.width,
                      child: Center(
                        child: Image.asset(
                          item,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        'Chức Năng Nổi Bật',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FeatureButton(
                          onTap: () {
                            Get.to(() => const AccountScreen(
                                  inDrawer: false,
                                ));
                          },
                          text: 'Cập Nhật Thông Tin'),
                      const SizedBox(width: 10),
                      FeatureButton(
                          onTap: () {
                            Get.to(() => const AddHealthRecord());
                          },
                          text: 'Thêm Hồ Sơ'),
                      const SizedBox(width: 10),
                      FeatureButton(
                          onTap: () {
                            Get.to(() => const AddVaccineHistory());
                          },
                          text: 'Thêm Lịch Sử Tiêm '),
                      const SizedBox(width: 10),
                      FeatureButton(
                          onTap: () {
                            Get.to(() => const AddUserManager());
                          },
                          text: 'Thêm Tài Khoản Con'),
                    ],
                  ),
                  if (userGlobal.type.value == 'admin')
                    const SizedBox(height: 10),
                  if (userGlobal.type.value == 'admin')
                    Row(
                      children: [
                        FeatureButton(
                            onTap: () {
                              Get.to(() => const AddVaccine());
                            },
                            text: 'Thêm Vắc-xin'),
                        const SizedBox(width: 10),
                        FeatureButton(
                            onTap: () {
                              Get.to(() => const AddLocation());
                            },
                            text: 'Thêm Cơ Sở Tiêm'),
                        const SizedBox(width: 20),
                        const Expanded(flex: 2, child: SizedBox())
                      ],
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Text(
                        'Cẩm Nang',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FeatureButton(onTap: () {}, text: 'Nâng Cao Sức khỏe'),
                      const SizedBox(width: 10),
                      FeatureButton(onTap: () {}, text: 'Thực Phẩm Sạch'),
                      const SizedBox(width: 10),
                      FeatureButton(onTap: () {}, text: 'Vắc-xin Phổ Biến'),
                      const SizedBox(width: 10),
                      FeatureButton(onTap: () {}, text: 'Phòng Tránh Bệnh'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder(
                stream:
                    GV.userCol.doc(uid).collection('userManagers').snapshots(),
                builder: (context, snapshot) {
                  final userManagers = snapshot.data?.docs;
                  userGlobal.userManager.value = [];
                  return snapshot.hasData && userManagers!.isNotEmpty
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Tài Khoản Quản Lý (${userManagers.length})',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              constraints: const BoxConstraints(
                                  minHeight: 0, maxHeight: 200),
                              child: ListView(
                                  shrinkWrap: true,
                                  children: userManagers.map((userManager) {
                                    userGlobal.userManager.add(UserManager(
                                      idU: userManager['idU'],
                                      name: userManager['name'],
                                      relationship: userManager['relationship'],
                                      avatar: userManager['avatar'],
                                    ));
                                    return InkWell(
                                      onTap: () {
                                        Get.to(() => AccountScreen(
                                              inDrawer: false,
                                              idUserManage: userManager['idU'],
                                              relationship:
                                                  userManager['relationship'],
                                            ));
                                      },
                                      child: GFListTile(
                                        avatar: GFAvatar(
                                          backgroundColor: Colors.grey.shade100,
                                          backgroundImage:
                                              userManager['avatar'] != ''
                                                  ? CachedNetworkImageProvider(
                                                      userManager['avatar']!,
                                                      cacheManager:
                                                          GV.customCacheManager,
                                                    )
                                                  : null,
                                          child: userManager['avatar'] == ''
                                              ? const Icon(Icons.person_outline)
                                              : null,
                                        ),
                                        titleText: userManager['name'],
                                        subTitleText:
                                            userManager['relationship'],
                                        icon: const Icon(
                                            Icons.mode_edit_outlined),
                                        color: Colors.white,
                                        shadow: const BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 1.0, //
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 3),
                                      ),
                                    );
                                  }).toList()),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Tài Khoản Quản Lý',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Center(
                                child: Text('Không có tài khoản nào!')),
                          ],
                        );
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Tin Tức',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Xem thêm',
                    style: TextStyle(fontSize: 13, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 170,
              width: Get.width - 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: index == 2
                          ? const EdgeInsets.only(right: 0)
                          : const EdgeInsets.only(right: 10),
                      child: Container(
                        width: Get.width - 90,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/banner5.jpg'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              height: 60,
                              width: Get.width,
                              color: Colors.white54,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Tìm hiểu thêm về Covid 19',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '    COVID-19 là gì? COVID-19 là một bệnh đường hô hấp truyền nhiễm do một loại coronavirus có tên là SARS-CoV-2 gây ra. \'CO\' là viết tắt của corona, \'VI\' là vi rút và \'D\' là bệnh.',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color.fromARGB(255, 2, 2, 2)),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  const FeatureButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });
  final String text;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            style: BorderStyle.solid,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: color ?? const Color.fromARGB(255, 235, 245, 255),
        ),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
