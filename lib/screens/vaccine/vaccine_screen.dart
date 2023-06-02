import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stronglier/common/add_floating_button.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';
import 'package:stronglier/screens/vaccine/widgets/add_vaccine.dart';
import 'package:stronglier/screens/vaccine/widgets/edit_vaccine.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  final userGlobal = Get.put(UserGlobal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: GV.vaccineCol.snapshots(),
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
                        children: snapshot.data!.docs.map((vaccine) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => EditVaccine(
                                    idV: vaccine['idV'],
                                    hasPermission:
                                        userGlobal.type.value == 'admin',
                                  ));
                            },
                            child: GFListTile(
                              color: Colors.white,
                              avatar: vaccine['imageUrl'] != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        cacheManager: GV.customCacheManager,
                                        key: UniqueKey(),
                                        imageUrl: vaccine['imageUrl'],
                                        height: 100,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.black12,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                color: Colors.black12,
                                                child: const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: 50,
                                                )),
                                      ),
                                    )
                                  : GFImageOverlay(
                                      height: 100,
                                      width: 120,
                                      image: const AssetImage(GV.noImage),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                              titleText: vaccine['vaccineName']!,
                              subTitle: Text(
                                vaccine['uses'],
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 2,
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
                                                        collection: 'vaccines',
                                                        doc: vaccine['idV']);
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
                Get.to(() => const AddVaccine());
              },
            )
          : null,
    );
  }
}
