import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stronglier/common/add_floating_button.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/screens/vac_facility/widgets/add_location.dart';
import 'package:stronglier/screens/vac_facility/widgets/edit_location.dart';

class VacFacilityScreen extends StatefulWidget {
  const VacFacilityScreen({super.key});

  @override
  State<VacFacilityScreen> createState() => _VacFacilityScreenState();
}

class _VacFacilityScreenState extends State<VacFacilityScreen> {
  final userGlobal = Get.put(UserGlobal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: GV.locationCol.snapshots(),
        builder: (context, snapshot) {
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
                        children: snapshot.data!.docs.map((location) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => EditLocation(
                                    idL: location['idL'],
                                    hasPermission:
                                        userGlobal.type.value == 'admin',
                                  ));
                            },
                            child: GFListTile(
                              color: Colors.white,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${location['facilityName']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ]),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Đơn vị quản lý: ${location['companyManager']}',
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 10,
                                  ),
                                  Text(
                                    'Địa chỉ: ${location['address']}',
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 10,
                                  ),
                                ],
                              ),
                              shadow: const BoxShadow(
                                color: Colors.black38,
                                blurRadius: 3.0, //
                              ),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              icon: userGlobal.type.value == 'admin'
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Cảnh báo',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              titleTextStyle: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.blue),
                                              content: const Text(
                                                  'Bạn có chắc chắc muốn xóa?'),
                                              actions: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text(
                                                    'Không',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  child: const Text('Có'),
                                                  onPressed: () async {
                                                    await deleteData(
                                                        collection:
                                                            'vacFacilities',
                                                        doc: location['idL']);
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
                          );
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
      floatingActionButton: userGlobal.type.value == 'admin'
          ? AddFloatingButton(
              onPressed: () {
                Get.to(() => const AddLocation());
              },
            )
          : null,
    );
  }
}
