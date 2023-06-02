import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronglier/common/custom_button.dart';
import 'package:stronglier/common/custom_textfield.dart';
import 'package:stronglier/common/function.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/common/user_controller.dart';

class EditVaccine extends StatefulWidget {
  const EditVaccine({
    Key? key,
    required this.idV,
    required this.hasPermission,
  }) : super(key: key);
  final String idV;
  final bool hasPermission;
  @override
  State<EditVaccine> createState() => _EditVaccineState();
}

class _EditVaccineState extends State<EditVaccine> {
  final GlobalKey<FormState> _vaccineFormKey = GlobalKey<FormState>();
  final userGlobal = Get.put(UserGlobal());
  Map<String, String> temp = {
    'vaccineName': '',
    'imageUrl': '',
    'uses': '',
    'makeBy': '',
    'makeIn': '',
    'timeNext': '',
    'totalVac': '',
  };

  getVaccine(vaccineData) {
    temp['vaccineName'] = vaccineData['vaccineName'];
    temp['imageUrl'] = vaccineData['imageUrl'];
    temp['uses'] = vaccineData['uses'];
    temp['makeBy'] = vaccineData['makeBy'];
    temp['makeIn'] = vaccineData['makeIn'];
    temp['timeNext'] = vaccineData['timeNext'];
    temp['totalVac'] = vaccineData['totalVac'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: widget.hasPermission
              ? const Text(
                  'Cập nhật vắc-xin',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              : const Text(
                  'Thông tin vắc-xin',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            constraints: BoxConstraints(minHeight: Get.bottomBarHeight),
            padding: const EdgeInsets.only(top: 15),
            child: StreamBuilder(
                stream: GV.vaccineCol.doc(widget.idV).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final vaccineData = snapshot.data!;
                    getVaccine(vaccineData);
                    return Column(
                      children: [
                        Center(
                          child: vaccineData['imageUrl'] != ''
                              ? InkWell(
                                  onTap: () async {
                                    if (widget.hasPermission) {
                                      await uploadImageVaccine();
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      cacheManager: GV.customCacheManager,
                                      key: UniqueKey(),
                                      imageUrl: vaccineData['imageUrl'],
                                      height: 150,
                                      width: 200,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
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
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    if (widget.hasPermission) {
                                      await uploadImageVaccine();
                                    }
                                  },
                                  child: GFImageOverlay(
                                    height: 150,
                                    width: 200,
                                    image: const AssetImage(GV.noImage),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                        ),
                        Form(
                          key: _vaccineFormKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              CustomTextField(
                                hintText: 'Tên vắc-xin',
                                initialValue: vaccineData['vaccineName'],
                                validator: (val) => val!.isNotEmpty
                                    ? null
                                    : 'Cần phải nhập tên vắc-xin.',
                                onChanged: (input) =>
                                    temp['vaccineName'] = input!,
                                enabled: widget.hasPermission,
                              ),
                              CustomTextField(
                                hintText: 'Công dụng',
                                initialValue: vaccineData['uses'],
                                validator: (val) => val!.isNotEmpty
                                    ? null
                                    : 'Cần nhập công dụng của vắc-xin.',
                                onChanged: (input) => temp['uses'] = input!,
                                enabled: widget.hasPermission,
                              ),
                              CustomTextField(
                                initialValue: vaccineData['makeBy'],
                                hintText: 'Công ty sản xuất',
                                onChanged: (input) => temp['makeBy'] = input!,
                                enabled: widget.hasPermission,
                              ),
                              CustomTextField(
                                initialValue: vaccineData['makeIn'],
                                hintText: 'Quốc gia sản xuất',
                                onChanged: (input) => temp['makeIn'] = input!,
                                enabled: widget.hasPermission,
                              ),
                              CustomTextField(
                                initialValue: vaccineData['totalVac'],
                                hintText: 'Tổng số mũi tiêm',
                                keyBoardType: TextInputType.number,
                                validator: (val) => val!.isNotEmpty &&
                                        int.parse(val) == 0
                                    ? 'Hãy nhập số lớn hơn hoặc bằng 1 hoặc để trống.'
                                    : null,
                                onChanged: (input) => temp['totalVac'] = input!,
                                enabled: widget.hasPermission,
                              ),
                              CustomTextField(
                                initialValue: vaccineData['timeNext'],
                                hintText: 'Thời gian tái chủng',
                                onChanged: (input) => temp['timeNext'] = input!,
                                enabled: widget.hasPermission,
                                keyBoardType: TextInputType.multiline,
                              ),
                              const SizedBox(height: 35),
                              if (widget.hasPermission)
                                CustomButton(
                                    text: 'Lưu',
                                    width: Get.width * 0.5,
                                    onTap: () async {
                                      if (_vaccineFormKey.currentState!
                                          .validate()) {
                                        GV.vaccineCol.doc(widget.idV).update({
                                          if (temp['vaccineName'] !=
                                              vaccineData['vaccineName'])
                                            'vaccineName': temp['vaccineName'],
                                          if (temp['uses'] !=
                                              vaccineData['uses'])
                                            'uses': temp['uses'],
                                          if (temp['makeBy'] !=
                                              vaccineData['makeBy'])
                                            'makeBy': temp['makeBy'],
                                          if (temp['makeIn'] !=
                                              vaccineData['makeIn'])
                                            'makeIn': temp['makeIn'],
                                          if (temp['timeNext'] !=
                                              vaccineData['timeNext'])
                                            'timeNext': temp['timeNext'],
                                          if (temp['totalVac'] !=
                                              vaccineData['totalVac'])
                                            'totalVac': temp['totalVac'],
                                        });
                                        if (temp['vaccineName'] !=
                                                vaccineData['vaccineName'] ||
                                            temp['makeBy'] !=
                                                vaccineData['makeBy'] ||
                                            temp['makeIn'] !=
                                                vaccineData['makeIn'] ||
                                            temp['timeNext'] !=
                                                vaccineData['timeNext'] ||
                                            temp['uses'] !=
                                                vaccineData['uses'] ||
                                            temp['totalVac'] !=
                                                vaccineData['totalVac']) {
                                          await EasyLoading.showSuccess(
                                              'Cập nhật thành công!');
                                        } else {
                                          await EasyLoading.showInfo(
                                              'Không có thông tin thay đổi!');
                                        }
                                      }
                                    }),
                              // const Expanded(child: SizedBox.shrink())
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox(
                      height: Get.bottomBarHeight,
                      child: const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  uploadImageVaccine() async {
    final imagePicker = ImagePicker();
    XFile? image;
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);
    if (image != null) {
      await EasyLoading.show(status: 'Đang tải ảnh lên!');
      String vacName;
      temp['vaccineName']!.isEmpty
          ? vacName = image.path.split('/').last
          : vacName =
              '${normalizeVie(temp['vaccineName']!.toLowerCase()).split(' ').join('-')}.${image.path.split('.').last}';
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('vaccine')
          .child('vaccine-$vacName')
          .putFile(file)
          .whenComplete(() => print('success'));

      var link = await snapshot.ref.getDownloadURL();
      await GV.vaccineCol.doc(widget.idV).update({
        'imageUrl': link,
      });
      setState(() {
        temp['imageUrl'] = link;
      });
      await EasyLoading.showSuccess('Thêm ảnh thành công!');
    } else {
      await EasyLoading.showError('Không tìm thấy ảnh nào!');
    }
  }
}
