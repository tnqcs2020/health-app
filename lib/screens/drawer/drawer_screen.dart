// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/screens/account/account_screen.dart';
import 'package:stronglier/screens/auth/auth_screen.dart';
import 'package:stronglier/screens/drawer/widgets/drawer_avatar.dart';
import 'package:stronglier/screens/drawer/widgets/drawer_tile.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/screens/drawer/widgets/drawer_items.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronglier/screens/health_record/widgets/edit_health_record.dart';
import 'package:stronglier/screens/vac_facility/widgets/edit_location.dart';
import 'package:stronglier/screens/vac_history/widgets/edit_vac_history.dart';
import 'package:stronglier/screens/vaccine/widgets/edit_vaccine.dart';

var indexClicked = 1;

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  TextEditingController textController = TextEditingController();
  final userGlobal = Get.put(UserGlobal());
  List<dynamic> searchData = [];
  final uid = GV.auth.currentUser!.uid;
  updateState(int index) {
    return () {
      setState(() {
        indexClicked = index;
      });
      Get.back();
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Cảnh báo',
                style: TextStyle(color: Colors.red),
              ),
              titleTextStyle: const TextStyle(fontSize: 30, color: Colors.blue),
              content: const Text('Bạn chắc chắn muốn thoát?'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'Không',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Có'),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            DrawerItems.menu[indexClicked],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu_outlined,
                  size: 30,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  child: const Icon(Icons.search),
                  onTap: () async {
                    searchData = [];
                    await GV.vaccineCol.get().then((value) => value.docs
                        .forEach((result) => searchData.add(result.data())));
                    await GV.locationCol.get().then((value) => value.docs
                        .forEach((result) => searchData.add(result.data())));
                    await GV.healthRecordCol
                        .get()
                        .then((value1) => value1.docs.forEach((result1) async {
                              result1.data()['idU'] == uid
                                  ? searchData.add(result1.data())
                                  : null;
                              await GV.userCol
                                  .doc(uid)
                                  .collection('userManagers')
                                  .get()
                                  .then((value2) => value2.docs.forEach(
                                      (result2) => result1.data()['idU'] ==
                                              result2.data()['idU']
                                          ? searchData.add(result1.data())
                                          : null));
                            }));
                    await GV.vacHistoryCol
                        .get()
                        .then((value1) => value1.docs.forEach((result1) async {
                              result1.data()['idU'] == uid
                                  ? searchData.add(result1.data())
                                  : null;
                              await GV.userCol
                                  .doc(uid)
                                  .collection('userManagers')
                                  .get()
                                  .then((value2) => value2.docs.forEach(
                                      (result2) => result1.data()['idU'] ==
                                              result2.data()['idU']
                                          ? searchData.add(result1.data())
                                          : null));
                            }));

                    showSearch(
                      context: context,
                      delegate: SearchPage(
                        items: searchData,
                        searchLabel: 'Tìm kiếm ...',
                        barTheme: ThemeData(
                            hintColor: Colors.white,
                            textSelectionTheme: const TextSelectionThemeData(
                                cursorColor: Colors.white,
                                selectionHandleColor: Colors.grey,
                                selectionColor: Colors.grey),
                            dividerColor: Colors.white,
                            inputDecorationTheme: const InputDecorationTheme(
                              border: InputBorder.none,
                            )),
                        searchStyle: const TextStyle(color: Colors.white),
                        suggestion: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Tìm kiếm theo tên vắc-xin hoặc tên cơ sở tiêm chủng.',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        failure: const Center(
                          child: Text('Không tìm thấy :('),
                        ),
                        filter: (search) => [
                          search['vaccineName'],
                          search['facilityName'],
                          search['date'],
                          search['dateOfInjection']
                        ],
                        builder: (search) => InkWell(
                          onTap: () {
                            search['vaccineName'] != null
                                ? Get.to(() => EditVaccine(
                                      idV: search['idV']!,
                                      hasPermission:
                                          userGlobal.type.value == 'admin',
                                    ))
                                : search['facilityName'] != null
                                    ? Get.to(() => EditLocation(
                                          idL: search['idL']!,
                                          hasPermission:
                                              userGlobal.type.value == 'admin',
                                        ))
                                    : search['date'] != null
                                        ? Get.to(() => EditHealthRecord(
                                              idHR: search['idHR']!,
                                              hasPermission:
                                                  uid == search['idU']!,
                                            ))
                                        : search['dateOfInjection'] != null
                                            ? Get.to(() => EditVacHistory(
                                                  idVH: search['idVH']!,
                                                  hasPermission: GV.auth
                                                          .currentUser!.uid ==
                                                      search['idU']!,
                                                ))
                                            : null;
                          },
                          child: GFListTile(
                            color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            title: search['vaccineName'] != null &&
                                    search['dateOfInjection'] == null
                                ? IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Vắc-xin',
                                              textAlign: TextAlign.center,
                                            )),
                                        const VerticalDivider(
                                          thickness: 0.7,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(search['vaccineName']!),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : search['facilityName'] != null
                                    ? IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Cơ sở tiêm',
                                                  textAlign: TextAlign.center,
                                                )),
                                            const VerticalDivider(
                                              thickness: 0.7,
                                              color: Colors.black,
                                            ),
                                            Expanded(
                                                flex: 7,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      search['facilityName']!,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      )
                                    : search['date'] != null
                                        ? IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Hồ sơ',
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                const VerticalDivider(
                                                  thickness: 0.7,
                                                  color: Colors.black,
                                                ),
                                                Expanded(
                                                    flex: 7,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Khám tại BV ${search['hospitalName']}',
                                                        ),
                                                        Text(
                                                            'Ngày ${search['date']}')
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          )
                                        : search['dateOfInjection'] != null
                                            ? IntrinsicHeight(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Lịch sử tiêm',
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    const VerticalDivider(
                                                      color: Colors.black,
                                                      thickness: 0.7,
                                                    ),
                                                    Expanded(
                                                        flex: 7,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Tiêm ${search['vacName']}',
                                                            ),
                                                            Text(
                                                                'Ngày ${search['dateOfInjection']}')
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : null,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Obx(
                  () => Text(
                    'Xin chào ${userGlobal.name.value}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
              )),
        ),
        body: indexClicked == 0
            ? const AccountScreen(inDrawer: true)
            : DrawerItems.page[indexClicked],
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      indexClicked = 0;
                    });
                    Get.back();
                  },
                  child: DrawerAvatar()),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerTile(
                      index: 1,
                      onTap: updateState(1),
                    ),
                    if (userGlobal.type.value == 'admin')
                      DrawerTile(
                        index: 2,
                        onTap: updateState(2),
                      ),
                    DrawerTile(
                      index: 3,
                      onTap: updateState(3),
                    ),
                    DrawerTile(
                      index: 4,
                      onTap: updateState(4),
                    ),
                    DrawerTile(
                      index: 5,
                      onTap: updateState(5),
                    ),
                    DrawerTile(
                      index: 6,
                      onTap: updateState(6),
                    ),
                    DrawerTile(
                      index: 7,
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Cảnh báo',
                                style: TextStyle(color: Colors.red),
                              ),
                              titleTextStyle: const TextStyle(
                                  fontSize: 30, color: Colors.blue),
                              content: const Text('Bạn có muốn đăng xuất?'),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text(
                                    'Không',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Có'),
                                  onPressed: () async {
                                    final SharedPreferences sharedPref =
                                        await SharedPreferences.getInstance();
                                    await sharedPref.remove('email');
                                    await GV.auth.signOut();
                                    userGlobal.setUser();
                                    setState(() {
                                      indexClicked = 1;
                                    });
                                    Get.offUntil(
                                        MaterialPageRoute(
                                            builder: (_) => const AuthScreen()),
                                        (route) => false);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const DrawerDivider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text(
                        'Stronglier',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: GV.drawerItemSelectedColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: GV.drawerItemColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const DrawerDivider(),
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

class DrawerDivider extends StatelessWidget {
  const DrawerDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: GV.drawerItemColor,
      indent: 3,
      endIndent: 3,
    );
  }
}
