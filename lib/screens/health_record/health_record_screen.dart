import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stronglier/common/add_floating_button.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/screens/health_record/widgets/add_health_record.dart';
import 'package:stronglier/screens/health_record/widgets/edit_health_record.dart';

class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  State<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  final userGlobal = Get.put(UserGlobal());
  final uid = GV.auth.currentUser!.uid;
  int total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: GV.healthRecordCol.snapshots(),
        builder: (context, snapshot) {
          total = 0;
          return (snapshot.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                )
              : snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: ListView(
                        children: snapshot.data!.docs.map((healthRecord) {
                          if (userGlobal.userManager.isNotEmpty) {
                            for (int i = 0;
                                i < userGlobal.userManager.length;
                                i++) {
                              if (healthRecord['idU'] ==
                                  userGlobal.userManager[i].idU) {
                                total = total + 1;
                                return itemRecordHealth(
                                    healthRecord, context, i);
                              } else if (healthRecord['idU'] == uid) {
                                total = total + 1;
                                return itemRecordHealth(
                                    healthRecord, context, null);
                              }
                            }
                          } else if (healthRecord['idU'] == uid) {
                            total = total + 1;
                            return itemRecordHealth(
                                healthRecord, context, null);
                          }
                          return SizedBox.shrink();
                        }).toList(),
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
      floatingActionButton: AddFloatingButton(
        onPressed: () {
          Get.to(() => const AddHealthRecord());
        },
      ),
    );
  }

  Widget itemRecordHealth(
      QueryDocumentSnapshot<Map<String, dynamic>> healthRecord,
      BuildContext context,
      int? inManager) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => EditHealthRecord(
                  idHR: healthRecord['idHR'],
                  hasPermission: healthRecord['idU'] == uid,
                ));
          },
          child: GFListTile(
            color: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Hồ sơ $total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ]),
                const SizedBox(height: 5),
                Text(
                  'Khám tại: ${healthRecord['hospitalName']}',
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
                Text(
                  'Ngày khám: ${healthRecord['date']}',
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                Text(
                  'Chuẩn đoán: ${healthRecord['sickName']}',
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
                // Text(
                //   'Kê đơn: ${healthRecord['drug']}',
                //   style: const TextStyle(
                //       overflow: TextOverflow.ellipsis),
                //   maxLines: 5,
                // ),
              ],
            ),
            shadow: const BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0, //
            ),
            margin: const EdgeInsets.only(bottom: 3),
            icon: healthRecord['idU'] == uid
                ? InkWell(
                    onTap: () {
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
                            content: const Text('Bạn có chắc chắc muốn xóa?'),
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
                                  await deleteData(
                                      collection: 'healthRecords',
                                      doc: healthRecord['idHR']);
                                  Get.back();
                                  await EasyLoading.showSuccess(
                                      'Đã xóa thành công!');
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.delete,
                    ),
                  )
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.done_all_outlined,
                size: 15,
              ),
              healthRecord['idU'] == uid
                  ? const Text(
                      'Bạn',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                    )
                  : inManager != null
                      ? Text(
                          userGlobal.userManager[inManager].name,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13),
                        )
                      : const Text(''),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Icon(
                  Icons.lens,
                  size: 5,
                ),
              ),
              Text(
                healthRecord['createdAt'],
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
