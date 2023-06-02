import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stronglier/common/add_floating_button.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/screens/vac_history/widgets/add_vac_history.dart';
import 'package:stronglier/screens/vac_history/widgets/edit_vac_history.dart';

class VacHistoryScreen extends StatefulWidget {
  const VacHistoryScreen({super.key});

  @override
  State<VacHistoryScreen> createState() => _VacHistoryScreenState();
}

class _VacHistoryScreenState extends State<VacHistoryScreen> {
  final userGlobal = Get.put(UserGlobal());
  final uid = GV.auth.currentUser!.uid;
  int total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: GV.vacHistoryCol.snapshots(),
        builder: (context, snapshot) {
          total = 0;
          return (snapshot.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                )
              : snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: ListView(
                        children: snapshot.data!.docs.map((vacHistory) {
                          if (userGlobal.userManager.isNotEmpty) {
                            for (int i = 0;
                                i < userGlobal.userManager.length;
                                i++) {
                              if (vacHistory['idU'] ==
                                  userGlobal.userManager[i].idU) {
                                total = total + 1;
                                return itemVacHistory(vacHistory, context, i);
                              } else if (vacHistory['idU'] == uid) {
                                total = total + 1;
                                return itemVacHistory(
                                    vacHistory, context, null);
                              }
                            }
                          } else if (vacHistory['idU'] == uid) {
                            total = total + 1;
                            return itemVacHistory(vacHistory, context, null);
                          }
                          return const SizedBox.shrink();
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
          Get.to(() => const AddVaccineHistory());
        },
      ),
    );
  }

  Widget itemVacHistory(QueryDocumentSnapshot<Map<String, dynamic>> vacHistory,
      BuildContext context, int? inManager) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => EditVacHistory(
                  idVH: vacHistory['idVH'],
                  hasPermission: vacHistory['idU'] == uid,
                ));
          },
          child: GFListTile(
            color: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Lịch sử tiêm $total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ]),
                const SizedBox(height: 5),
                Text(
                  'Vắc-xin: ${vacHistory['vacName']} - Mũi: ${vacHistory['numOfVac']}',
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                  // maxLines: 2,
                ),
                Text(
                  'Tại: ${vacHistory['location']}',
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                  // maxLines: 2,
                ),
                Text(
                  'Ngày: ${vacHistory['dateOfInjection']}',
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                  // maxLines: 2,
                ),
              ],
            ),
            shadow: const BoxShadow(
              color: Colors.black38,
              blurRadius: 5.0, //
            ),
            margin: const EdgeInsets.only(bottom: 3),
            icon: vacHistory['idU'] == uid
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
                                      collection: 'vaccineHistorys',
                                      doc: vacHistory['idVH']);

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
              vacHistory['idU'] == uid
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
                vacHistory['createdAt'],
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
