import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final userGlobal = Get.put(UserGlobal());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: GV.userCol.snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                )
              : snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                Text.rich(
                                  TextSpan(text: 'Có ', children: [
                                    TextSpan(
                                        text: '${snapshot.data!.docs.length}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const TextSpan(text: ' người dùng.')
                                  ]),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((user) {
                              return InkWell(
                                onTap: () {
                                  // Get.to(() => EditLocation(
                                  //       idL: user['idL'],
                                  //       hasPermission:
                                  //           userGlobal.type.value == 'admin',
                                  //     ));
                                },
                                child: GFListTile(
                                  color: Colors.white,
                                  title: Text(
                                    '${user['name']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  subTitle: Text(
                                    '${user['email']}',
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 10,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: const [
                        Center(
                          child: Text('Không có dữ liệu!'),
                        ),
                      ],
                    );
        },
      ),
    );
  }
}
